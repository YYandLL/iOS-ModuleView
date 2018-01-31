//
//  TXBYKit.h
//  TXBYKit
//
//  Created by mac on 16/4/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

// 医院ID
NSString *TXBYHospital;
// app_type
NSString *TXBYApp_type;
// 医院分支
NSString *TXBYBranch;

// 导航栏高度
CGFloat const TXBYNavH = 44;
// tabbar高度
CGFloat const TXBYTabbarH = 49;
// cell之间的间距
CGFloat const TXBYCellMargin = 10;
// 接口调用成功
NSString *const TXBYSuccessCode = @"0";

// 刷新token网络标识
NSString *const TXBYRefreshTokenNetIdentifier = @"TXBYRefreshTokenNetIdentifier";
// 注销token网络标识
NSString *const TXBYRevokeTokenNetIdentifier = @"TXBYRevokeTokenNetIdentifier";
// 变更DeviceToken网络标识
NSString *const TXBYDeviceTokenNetIdentifier = @"TXBYDeviceTokenNetIdentifier";


#ifdef DEBUG

// 智能分诊症状列表
NSString *const TXBYTriageSymptomListAPI = @"http://192.168.2.11:18088/v2/smart_triage/symptom.jsp";
// 智能分诊疾病列表
NSString *const TXBYTriageIllListAPI = @"http://192.168.2.11:18088/v2/smart_triage/disease.jsp";


// 问题列表
NSString *const TXBYQuestListAPI = @"http://192.168.2.46:8080/v2/quest/quests";
// 问题详情
NSString *const TXBYQuestDetailAPI = @"http://192.168.2.46:8080/v2/quest/show";
// 提问
NSString *const TXBYQuestAddAPI = @"http://192.168.2.46:8080/v2/quest/create";
// 回复问题
NSString *const TXBYQuestReplyAPI = @"http://192.168.2.46:8080/v2/quest/reply";
// 我的问题
NSString *const TXBYMyQuestAPI = @"http://192.168.2.46:8080/v2/quest/my";


// 科室介绍列表
NSString *const TXBYDeptIntroduceListAPI = @"http://192.168.2.11:18088/v2/dept/depts";
// 科室介绍详情
NSString *const TXBYDeptIntroduceDetailAPI = @"http://192.168.2.11:18088/v2/dept/show";
// 服务价格
NSString *const TXBYServiceAPI = @"http://www.szyyjg.com/androidapi/jqm/ServiceTypeQuery.jsp";
// 服务条款
NSString *const TXBYAgreementAPI = @"http://demoapi.eeesys.com:18088/v2/agree/agreement";
// 药价公示
NSString *const TXBYDrugListAPI = @"http://www.szyyjg.com/androidapi/medic_prices.jsp";
#pragma mark - 交流区接口
// 交流区分类
NSString *const TXBYCommunityGroupAPI = @"http://demoapi.eeesys.com:18088/v2/quest/group";
// 交流区列表
NSString *const TXBYCommunityListAPI = @"http://demoapi.eeesys.com:18088/v2/quest/quests";
// 交流区thumb图片
NSString *const TXBYCommunityThumbAPI = @"http://cloud.eeesys.com/pu/thumb.php";
// 交流区点赞和踩
NSString *const TXBYCommunityLoveAPI = @"http://demoapi.eeesys.com:18088/v2/operate/create";
// 交流区取消点赞和踩
NSString *const TXBYCommunityCancelLoveAPI = @"http://demoapi.eeesys.com:18088/v2/operate/cancel";
// 交流区点赞和点踩人数
NSString *const TXBYCommunityPersonAPI = @"http://demoapi.eeesys.com:18088/v2/quest/love";
// 交流区上传请求
NSString *const TXBYCommunityUploadImageAPI = @"http://cloud.eeesys.com/pu/upload.php";
#else

// 智能分诊症状列表
NSString *const TXBYTriageSymptomListAPI = @"http://api.eeesys.com:18088/v2/smart_triage/symptom.jsp";
// 智能分诊疾病列表
NSString *const TXBYTriageIllListAPI = @"http://api.eeesys.com:18088/v2/smart_triage/disease.jsp";


// 问题列表
NSString *const TXBYQuestListAPI = @"http://api.eeesys.com:18088/v2/quest/quests";
// 问题详情
NSString *const TXBYQuestDetailAPI = @"http://api.eeesys.com:18088/v2/quest/show";
// 提问
NSString *const TXBYQuestAddAPI = @"http://api.eeesys.com:18088/v2/quest/create";
// 回复问题
NSString *const TXBYQuestReplyAPI = @"http://api.eeesys.com:18088/v2/quest/reply";
// 我的问题
NSString *const TXBYMyQuestAPI = @"http://api.eeesys.com:18088/v2/quest/my";

// 科室介绍列表
NSString *const TXBYDeptIntroduceListAPI = @"http://api.eeesys.com:18088/v2/dept/depts";
// 科室介绍详情
NSString *const TXBYDeptIntroduceDetailAPI = @"http://api.eeesys.com:18088/v2/dept/show";
// 服务价格
NSString *const TXBYServiceAPI = @"http://www.szyyjg.com/androidapi/jqm/ServiceTypeQuery.jsp";
// 服务条款
NSString *const TXBYAgreementAPI = @"http://api.eeesys.com:18088/v2/agree/agreement";
// 药价公示
NSString *const TXBYDrugListAPI = @"http://www.szyyjg.com/androidapi/medic_prices.jsp";
#pragma mark - 交流区接口
// 交流区分类
NSString *const TXBYCommunityGroupAPI = @"http://api.eeesys.com:18088/v2/quest/group";
// 交流区列表
NSString *const TXBYCommunityListAPI = @"http://api.eeesys.com:18088/v2/quest/quests";
// 交流区thumb图片
NSString *const TXBYCommunityThumbAPI = @"http://cloud.eeesys.com/pu/thumb.php";
// 交流区点赞和踩
NSString *const TXBYCommunityLoveAPI = @"http://api.eeesys.com:18088/v2/operate/create";
// 交流区取消点赞和踩
NSString *const TXBYCommunityCancelLoveAPI = @"http://api.eeesys.com:18088/v2/operate/cancel";
// 交流区点赞和点踩人数
NSString *const TXBYCommunityPersonAPI = @"http://api.eeesys.com:18088/v2/quest/love";
// 交流区上传请求
NSString *const TXBYCommunityUploadImageAPI = @"http://cloud.eeesys.com/pu/upload.php";
#endif