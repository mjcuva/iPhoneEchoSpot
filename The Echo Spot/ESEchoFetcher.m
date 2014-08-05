//
//  ESEchoFetcher.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/4/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESEchoFetcher.h"
#import "ESCategory.h"
#import "ESComment.h"
#import "ESDiscussion.h"
#import "constants.h"
#import "ESAuthenticator.h"

@implementation ESEchoFetcher

+ (NSArray *)getDataForURL: (NSString *)url{
    NSError *err;
    NSURL *jsonUrl = [NSURL URLWithString:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *json = [NSData dataWithContentsOfURL: jsonUrl options:NSDataReadingMappedIfSafe error:&err];
   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(err) {
        NSLog(@"Error Loading URL: %@", [err description]);
        return nil;
    }
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:&err];
    if(err){
        NSLog(@"%@", [err description]);
    }
    return jsonObject;
}

+ (NSArray *)loadEchosOnPage:(int)page withSorting:(sortType)sorting{
    
    NSArray *jsonObject = [self getDataForURL:[self echoURLWithUser:[[ESAuthenticator sharedAuthenticator] currentUser] index:page sortType:sorting]];
    
    if(jsonObject == nil){
        return nil;
    }
    
    NSArray *echos = [self echosForData:jsonObject];
    
    
    return echos;
}

+ (NSArray *)echosForData:(NSArray *)data{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for( NSDictionary *echo in data){
        ESEcho *newEcho = [[ESEcho alloc] init];
        newEcho.title = echo[@"title"];
        newEcho.echoID = [echo[@"id"] intValue];
        
        if([echo[@"thumbnail_url"] isEqualToString:@""]){
            newEcho.imageThumbURL = nil;
            newEcho.imageFullURL = nil;
        }else{

            newEcho.imageThumbURL = [NSURL URLWithString:echo[@"thumbnail_url"]];
            newEcho.imageFullURL = [NSURL URLWithString:echo[@"original_url"]];
            NSData *data = [NSData dataWithContentsOfURL:newEcho.imageFullURL];
            UIImage *image = [UIImage imageWithData:data];
            newEcho.image = image;
        }

        
        if([echo[@"votes_up"] isKindOfClass:[NSNull class]]){
            newEcho.votesUp = 0;
        }else{
            newEcho.votesUp = [echo[@"votes_up"] intValue];
        }
        
        if([echo[@"votes_down"] isKindOfClass:[NSNull class]]){
            newEcho.votesDown = 0;
        }else{
            newEcho.votesDown = [echo[@"votes_down"] intValue];   
        }
        
        newEcho.activity = [echo[@"activity"] intValue];
        newEcho.content = echo[@"content"];
        newEcho.created = [NSDate dateWithTimeIntervalSince1970:[echo[@"created_at"] doubleValue]];
        newEcho.category = [[ESCategory alloc] initWithName:echo[@"category"][@"name"] andCatID:[echo[@"category"][@"id"] intValue]];
        newEcho.voteStatus = [echo[@"voted_on"] intValue];
        
        if(echo[@"user"] == [NSNull null]){
            newEcho.author = [ESUser deletedUser];
        }else if([echo[@"anonymous"] boolValue] == 1){
            newEcho.author = [ESUser anonymousUser];
        }else{
            newEcho.author = [[ESUser alloc] initWithName:echo[@"user"][@"username"] andID:[echo[@"user"][@"id"] intValue]];
        }
        [returnArray addObject:newEcho];
    }
    
    return returnArray;

}

+ (NSArray *)loadCommentsForEcho: (NSInteger)echoID{
    NSArray *jsonObject = [self getDataForURL:[self commentURLWithUser:0 echoID:(int)echoID sortType:sortVotes]];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *comment in jsonObject) {
        ESComment *newComment = [[ESComment alloc] init];
        newComment.comment_text = comment[@"content"];
        newComment.commentID = [comment[@"id"] intValue];
        
        if(comment[@"user"] == [NSNull null]){
            newComment.author = [ESUser deletedUser];
        }else if([comment[@"anonymous"] boolValue] == 1){
            newComment.author = [ESUser anonymousUser];
        }else{
            newComment.author = [[ESUser alloc] initWithName:comment[@"user"][@"username"] andID:[comment[@"user"][@"id"] intValue]];    
        }

        if([comment[@"votes_down"] isKindOfClass:[NSNull class]]){
            newComment.votesDown = 0;
        }else{
            newComment.votesDown = [comment[@"votes_down"] intValue];
        }
        
        if([comment[@"votes_up"] isKindOfClass:[NSNull class]]){
            newComment.votesUp = 0;
        }else{
            newComment.votesUp = [comment[@"votes_up"] intValue];
        }
        
        newComment.voteStatus = [comment[@"voted_on"] intValue];
        
        newComment.created = [NSDate dateWithTimeIntervalSince1970:[comment[@"created_at"] intValue]];
        NSMutableArray *discussions = [[NSMutableArray alloc] init];
        for(NSDictionary *discussion in comment[@"discussions"]){
            ESDiscussion *newDiscussion = [[ESDiscussion alloc] init];
            newDiscussion.discussionID = [discussion[@"id"] intValue];
            newDiscussion.discussion_text = discussion[@"content"];
            if(discussion[@"user"] == [NSNull null]){
                newDiscussion.author = [ESUser deletedUser];
            }else if([discussion[@"anonymous"] boolValue] == 1){
                newDiscussion.author = [ESUser anonymousUser];
            }else{
                newDiscussion.author = [[ESUser alloc] initWithName:discussion[@"user"][@"username"] andID:[discussion[@"user"][@"id"] intValue]];
            }
            newDiscussion.created = [NSDate dateWithTimeIntervalSince1970:[discussion[@"created_at"] intValue]];
            [discussions addObject:newDiscussion];
        }
        newComment.discussions = discussions;
        
        [returnArray addObject:newComment];
        
    }
    
    return returnArray;
}

+ (NSArray *)echosForUser:(int)user{
    NSArray *jsonData = [self getDataForURL:[self echosForUserURL:user]];
    NSArray *echos = [self echosForData:jsonData];
    return echos;
}

+ (BOOL)voteOnPostType: (NSString *)type withID: (int)echoID withValue: (int)voteType{
    
    NSString *post = [NSString stringWithFormat:@"user_id=%i&target_type=%@&target_id=%i&value=%i", [[ESAuthenticator sharedAuthenticator] currentUser], type, echoID, voteType];
    BOOL success = [self postRequestWithData:post toURL:[self voteURL]];
    return success;
}

+ (BOOL)postComment:(NSString *)content onEchoID:(int)echoID anonymously:(BOOL)anon{
    NSString *anonymous;
    if(anon){
        anonymous = @"true";
    }else{
        anonymous = @"false";
    }
    BOOL success = [self postRequestWithData:[NSString stringWithFormat:@"echo_id=%i&user_id=%i&comment_text=%@&anonymous=%@", echoID, [[ESAuthenticator sharedAuthenticator] currentUser], content, anonymous] toURL:[self postCommentURL]];
    return success;
}

+ (BOOL)postDiscussion:(NSString *)content onCommentID:(int)commentID anonymously:(BOOL)anon{
    NSString *anonymous;
    if(anon){
        anonymous = @"true";
    }else{
        anonymous = @"false";
    }
    BOOL success = [self postRequestWithData:[NSString stringWithFormat:@"comment_id=%i&user_id=%i&discussion_text=%@&anonymous=%@", commentID, [[ESAuthenticator sharedAuthenticator] currentUser], content, anonymous] toURL:[self postDiscussionURL]];
    return success;
}

+ (BOOL)postEchoWithData:(NSDictionary *)data{
    BOOL success = [self postRequestWithData:[NSString stringWithFormat:@"user_id=%i&content=%@&title=%@&anonymous=%@&category=%@&image=null", [[ESAuthenticator sharedAuthenticator] currentUser], data[@"content"], data[@"title"], data[@"anonymous"], data[@"category"]] toURL:[self postEchoURL]];
    return success;
}

+ (BOOL)postRequestWithData: (NSString *)post toURL: (NSString *)url{
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error){
        NSLog(@"%@", [error description]);
    }
    NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    if([str isEqualToString:@"success"]){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)usernameForCurrentUser{
    NSDictionary *data = (NSDictionary *)[self getDataForURL:[self usernameURL]];
    return data[@"username"];
}

+ (NSString *)voteURL{
    return [NSString stringWithFormat:@"%@vote", BASE_URL];
}

+ (NSString *)postCommentURL{
    return [NSString stringWithFormat:@"%@comment", BASE_URL];
}

+ (NSString *)postDiscussionURL{
    return [NSString stringWithFormat:@"%@discussion", BASE_URL];
}

+ (NSString *)postEchoURL{
    return [NSString stringWithFormat:@"%@echo", BASE_URL];
}

+ (NSString *)echosForUserURL:(int)user{
    return [NSString stringWithFormat:@"%@echo/%i/%i", BASE_URL, user, user];
}

+ (NSString *)usernameURL{
    return [NSString stringWithFormat:@"%@%@/%i", BASE_URL, @"user", [ESAuthenticator horribleProgrammingCurrentUser]];
}

+ (NSString *)nameForSortType: (sortType)type{
    switch (type) {
        case sortTrending:
            return @"trending";
            break;
        case sortVotes:
            return @"votes";
            break;
        case sortRecent:
            return @"recent";
            break;
        default:
            NSLog(@"YOU DONE FUCKED UP");
            break;
    }
}

+ (NSString *)echoURLWithUser: (int)userID index: (int)index sortType: (sortType)sortType{
    NSString *sort = [self nameForSortType:sortType];
    return [NSString stringWithFormat:@"%@echo/%i/%i/%@", BASE_URL, userID, index, sort];
}

+ (NSString *)commentURLWithUser: (int)userID echoID: (int)echoID sortType: (sortType)sortType{
    NSString *sort = [self nameForSortType:sortType];
    return [NSString stringWithFormat:@"%@comment/%i/%i/%@", BASE_URL, echoID, userID, sort];
}

@end
