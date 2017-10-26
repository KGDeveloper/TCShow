//
//  IMAGroup+MemberList.m
//  TIMChat
//
//  Created by wilderliao on 16/3/25.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAGroup+MemberList.h"

@implementation IMAGroup (MemberList)

- (void)asyncInviteMembers:(NSArray *)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail
{
    if (!members)
    {
        
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (IMAUser *u in members)
    {
        [array addObject:[u userId]];
    }
    
    [[TIMGroupManager sharedInstance] InviteGroupMember:self.userId members:array succ:succ fail:^(int code, NSString *err) {
        
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
        if (fail)
        {
            fail(code, err);
        }
    }];
}

- (void)asyncMembersV2Of:(RequestPageParamItem *)item succ:(TIMGroupMembers)succ fail:(TIMFail)fail
{
    [[TIMGroupManager sharedInstance] GetGroupMembersV2:self.groupInfo.group flags:TIM_GET_GROUP_MEM_INFO_FLAG_ROLE_INFO|TIM_GET_GROUP_MEM_INFO_FLAG_SHUTUP_TIME|TIM_GET_GROUP_MEM_INFO_FLAG_NAME_CARD custom:nil nextSeq:item.pageIndex succ:^(uint64_t nextSeq, NSArray *array){
        NSMutableArray *admins = [NSMutableArray array];
        NSMutableArray *otherMembers = [NSMutableArray array];
        
        for (TIMGroupMemberInfo *info in array)
        {
            IMAGroupMember *user = [[IMAGroupMember alloc] initWithMemberInfo:info];
            
            if (info.role == TIM_GROUP_MEMBER_ROLE_ADMIN ||
                info.role == TIM_GROUP_MEMBER_ROLE_SUPER)
            {
                [admins addObject:user];
            }
            else if (info.role == TIM_GROUP_MEMBER_ROLE_MEMBER)
            {
                [otherMembers addObject:user];
            }
        }
        item.pageIndex = nextSeq;
        item.canLoadMore = nextSeq != 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (succ)
            {
                succ(nextSeq, admins, otherMembers);
            }
        });
    } fail:^(int code, NSString *err){
       
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, err)];
        if (fail)
        {
            fail(code, err);
        }
    }];
}

- (void)asyncMembersOf:(TIMGroupMemberSucc)succ fail:(TIMFail)fail
{
    [[TIMGroupManager sharedInstance] GetGroupMembers:self.groupId succ:^(NSArray *arr) {
        if (succ)
        {
            succ(arr);
        }
    } fail:^(int code, NSString *msg) {
        
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncRemoveMembersOf:(NSArray *)members succ:(TIMGroupMemberSucc)succ fail:(TIMFail)fail
{
    if (!members)
    {
        
        return;
    }
    
    [[TIMGroupManager sharedInstance] DeleteGroupMember:self.groupInfo.group members:members succ:^(NSArray *members) {
        if (succ)
        {
            succ(members);
        }
    } fail:^(int code, NSString *msg) {
        
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

- (void)asyncGetGroupMemberInfo:(NSString *)members succ:(TIMGroupMemberInfoSucc)succ fail:(TIMFail)fail;
{
    if (!members)
    {
        
        return;
    }
    
    [[TIMGroupManager sharedInstance] GetGroupMembersInfo:self.groupId members:@[members] succ:^(NSArray *members) {
        if (succ)
        {
            if (members.count > 0)
            {
                succ(members[0]);
            }
            else
            {
                succ(nil);
            }
        }
    } fail:^(int code, NSString *msg) {
        
        [[HUDHelper sharedInstance] tipMessage:IMALocalizedError(code, msg)];
        
        if (fail)
        {
            fail(code, msg);
        }
    }];
}

@end
