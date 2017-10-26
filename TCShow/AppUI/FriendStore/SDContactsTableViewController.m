//
//  SDContactsTableViewController.m


#import "SDContactsTableViewController.h"
#import "SDContactsSearchResultController.h"

#import "SDContactModel.h"
#import "SDAnalogDataGenerator.h"
#import "IMAUser.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "IMAChatViewController.h"
#import "SDContactsTableViewCell.h"
#import "XDContactHeaderView.h"
#import "AddFriendViewController.h"
@interface SDContactsTableViewController () <UITableViewDelegate,UITableViewDataSource>{
    MJRefreshNormalHeader *_header;
}

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic,strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSDictionary * contactDic;
@end

@implementation SDContactsTableViewController

- (void)viewDidLoad {
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    UIView *contactHeaderView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([XDContactHeaderView class]) owner:nil options:nil]firstObject];
    contactHeaderView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 260);
    XDContactHeaderView *contactView = [XDContactHeaderView new];
    contactView = (XDContactHeaderView *)contactHeaderView;
    contactView.parentVC = self;
    self.tableView.tableHeaderView = contactHeaderView;
    self.tableView.rowHeight = [SDContactsTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = RGBA(69, 69, 69, 1.0);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    UIBarButtonItem *rightAtem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contact_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightAtemClick)];
    self.navigationItem.rightBarButtonItem = rightAtem;
    [self setUpRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadViewUI];
    [self genDataWithCount];
}

-(void)setUpRefresh{
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(genDataWithCount)];
    self.tableView.header = _header;
    _header.stateLabel.hidden = YES;
    _header.lastUpdatedTimeLabel.hidden = YES;
}

-(void)loadViewUI{
    _contactDic = [SARUserInfo gainContacts];
    _dataArray = [SDContactModel mj_objectArrayWithKeyValuesArray:_contactDic[@"data"] context:nil];
    [self setUpTableSection];
    [_tableView reloadData];
}

-(void)rightAtemClick{
    
    AddFriendViewController *vc = [[AddFriendViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


//获取联系人列表
- (void)genDataWithCount{
    [[Business sharedInstance] friendList:[SARUserInfo userId] succ:^(NSString *msg, id data) {
        if ([data[@"code"] integerValue] == 0) {
            _dataArray = [SDContactModel mj_objectArrayWithKeyValuesArray:data[@"data"] context:nil];
            [self setUpTableSection];
            [SARUserInfo saveContacts:data];
            [_tableView reloadData];
        }else{
            [[HUDHelper sharedInstance] tipMessage:msg];
        }
        [self.tableView.header endRefreshing];
        
    } fail:^(NSString *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (SDContactModel *model in self.dataArray) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(nickname)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSMutableArray * sortedPersonsForSection = [NSMutableArray arrayWithArray:[collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(nickname)]];
        newSectionArray[index] = sortedPersonsForSection;
    }
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray arrayWithCapacity:0];
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    [newSectionArray removeObjectsInArray:temp];
    self.sectionArray = newSectionArray;
}

#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SDContacts";
    SDContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SDContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    SDContactModel *model = self.sectionArray[section][row];
    cell.model = model;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 25.0)];
    view.backgroundColor = RGBA(244, 243, 251, 1.0);
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kSCREEN_WIDTH - 100, 25.0)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = [self.sectionTitlesArray objectAtIndex:section];
    label.textColor = RGBA(69, 69, 69, 1.0);
    [view addSubview:label];
    return view;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SDContactModel * model= self.sectionArray[indexPath.section][indexPath.row];
    IMAUser *user = [[IMAUser alloc]init];
    user.userId = model.phone;
    user.icon = model.headsmall;
    user.remark = model.nickname;
    user.nickName = model.nickname;
//    // 进入C2C聊天界面
//    id<SDContactModel> drawer = [_contact objectAtIndex:indexPath.section-1];
//    IMAUser *user = (IMAUser *)[[drawer items] objectAtIndex:indexPath.row];
//    
//    //跳转到AIO
    [AppDelegate sharedAppDelegate].isContactListEnterChatViewController = YES;
//
    [self pushToChatViewControllerWith:user];
}

//提交编辑结果时会调用这个方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDContactModel * model = _sectionArray[indexPath.section][indexPath.row];
    //如果模式是删除模式 则删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[Business sharedInstance] delegateFriend:[SARUserInfo userId] friend_phone:model.phone succ:^(NSString *msg, id data) {
            if ([data[@"code"] integerValue] == 0) {
                //1.从数据源中删除数据
                [_sectionArray[indexPath.section] removeObjectAtIndex:indexPath.row];
                //2.从视图上删除cell
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self genDataWithCount];
            }else{
                [[HUDHelper sharedInstance] tipMessage:msg];
            }
        } fail:^(NSString *error) {
            [[HUDHelper sharedInstance] tipMessage:error];
        }];
        return;
    }
}

//插入与删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //其他的cell在进入编辑模式时 返回删除模式
    return UITableViewCellEditingStyleDelete;
}

- (void)pushToChatViewControllerWith:(IMAUser *)user{
#if kTestChatAttachment
    // 无则重新创建
    ChatViewController *vc = [[CustomChatUIViewController alloc] initWith:user];
#else
    ChatViewController *vc = [[IMAChatViewController alloc] initWith:user];
#endif
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc withBackTitle:@"返回" animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}



@end
