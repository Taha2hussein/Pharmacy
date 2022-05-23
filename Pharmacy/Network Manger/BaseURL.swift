//
//  BaseURL.swift
//  MachhineTest
//
//  Created by A on 24/12/2021.
//


//         const val BASE_URL = "https://e4clinicdevapi.ekadsoft.org/"         //todo dev
//        const val BASE_URL = "https://e4clinictestapi.ekadsoft.org/"         //todo test
//        const val BASE_URL = "https://e4clinicpilotapi.ekadsoft.org/"      //todo client


import Foundation
var headers: [String: String] = ["Content-Type": "multipart/form-data","lang": getCurrentLanguage()]

let baseUrl = "https://e4clinictestapi.ekadsoft.org/api"
let baseURLImage = "https://e4clinictestapi.ekadsoft.org/"
let login = baseUrl + "login"
let changePasswordApi = baseUrl + "/Common/ChangePasswordByOldPassword"
let countrys = baseUrl + "/Lookup/Country_get_all_full"
let registerApi = baseUrl + "/Pharmacy/RegisterPharmacy"
let activationCodeApi = baseUrl + "/Common/ActivateCode"
let loginApi = baseUrl + "/Common/Login"
let dashboardApi = baseUrl + "/Pharmacy/PharmacyDashboard"
let walletSummary = baseUrl + "/Pharmacy/GetWaletSummery"
let walletBrnach = baseUrl + "/Pharmacy/GetWaletBranchList"
let PharmacyDashboardBranchesApi = baseUrl + "/Pharmacy/PharmacyDashboardBranches"
let rechargePharmacy = baseUrl + "/Pharmacy/chargePharmacyWalet"
let walletTransactionList = baseUrl + "/Pharmacy/GetWaletTransactionList"
let profileApi = baseUrl + "/Pharmacy/PharmacistProfile?PharmacyProviderEmployeeID="
let editProfileApi = baseUrl + "/Pharmacy/SavePharmacyProviderEmployee"
let bligsListApi = baseUrl + "/Common/GetBlogList"
let likeBlogApi = baseUrl + "/Common/LikeBlogByID"
let unlikeBlogApi = baseUrl + "/Common/UnLikeBlogByID"
let pharmcyProfile = baseUrl + "/Pharmacy/PharmacyProfile"
let blogDetailsApi = baseUrl + "/Common/GetBlogByID"
let logoutApi = baseUrl + "/Common/Logout"
let forgetPasswordFirstApi = baseUrl + "/Common/ForgetPassword"
let forgetPasswordSecondApi = baseUrl + "/Common/ValidateForgetToken"
let forgetPasswordthirdApi = baseUrl + "/Common/ChangePasswordAfterForget"
let addOrEditPharmacy = baseUrl + "/Pharmacy/SavePharmacyBranch"
let addPharmacistApi = baseUrl + "/Pharmacy/SavePharmacyProviderEmployee"
let activeBranchApi = baseUrl + "/Pharmacy/UpdatePharmacyBranchStatus?"
let activePharmacistApi = baseUrl + "/Pharmacy/ActivateOrDeactivePharmacist?"
let deleteBranchApi = baseUrl + "/Pharmacy/DeletePharmacyBranch?"
let previousOrderList = baseUrl + "/Pharmacy/GetOrderListForPharmacy"
let orderListApi = baseUrl + "/Pharmacy/GetOrderListForPharmacy"
let cancelOrderApi = baseUrl + "/Pharmacy/GetOrderDetailsForPharmacy"
let AllBranchesApi = baseUrl + "/Pharmacy/GetPharmacyBranchesForCurrentUser"
let orderTrackingApi = baseUrl + "/Pharmacy/GetOrderDetailsForPharmacy"
let acceptPharmacyOrederApi = baseUrl + "/Pharmacy/AcceptOrderByPharmacy"
let cancelOrderReasonsApi = baseUrl + "/Lookup/GetLookupCancellationReason?type=2"
let rejectOrderApi = baseUrl + "/Pharmacy/RejectOrderByPharmacy"
let findMedicineApi = baseUrl + "/Pharmacy/Medicine_Search"
let filterCatogryApi =  baseUrl + "/Pharmacy/SearchMedicineCategories"
let filterBrandApi =  baseUrl + "/Pharmacy/GetLookupCompines"
let saveOrderToCustomer = baseUrl + "/Pharmacy/SaveOrderOffer"
let accectPricingApi = baseUrl + "/Pharmacy/SendOfferToCustomer?PharmacyOrderOfferId="
let finishOrderApi = baseUrl + "/Pharmacy/MarkOrderAsDelivered?PharmacyOrderId="
let totalDialyOrdersApi = baseUrl + "/Pharmacy/PharmacyDashboardTotalDailyOrders"
let uploadImageApi = baseUrl + "/Common/FormDataUpload"
let notificationCountApi = baseUrl + "/Pharmacy/GetNotReadNotificationCount"
let editBranchApi = baseUrl + "/Pharmacy/GetPharmacyBranchData?PharmacyProviderBranchID="
let editPharmacistApi = baseUrl + "/Pharmacy/PharmacistProfile?PharmacyProviderEmployeeID="
let basicDataApi = baseUrl + "/Pharmacy/GetPharmacyBasicData?PharmacyID="
let updateBasicDataApi = baseUrl  + "/Pharmacy/UpdatePharmacyBasicData"
let pharmacistProfileApi = baseUrl + "/Pharmacy/PharmacistProfile?PharmacyProviderEmployeeID="
let contacyUsApi =  baseUrl + "/Common/SaveContactUs"
let commonWEBPage = baseUrl + "/Common/GetFullWebPages"
let rateApi = baseUrl + "/Pharmacy/getPharmacyRate?PharmacyID="
let saveReplay = baseUrl + "/Pharmacy/SaveReviewReply"
let FAQApi = baseUrl + "/Common/Gethelpsupport"
let notificationListApi = baseUrl + "/Pharmacy/GetNotificationList"
let deleteNotficationApi = baseUrl + "/Pharmacy/DeleteNotification?NotificationID="
let markNotificationReadApi = baseUrl + "/Pharmacy/MarkAsReadNotification?NotificationID="
let markAllNotificationsReadApi = baseUrl + "/Pharmacy/MarkAsReadAllNotification"
let deleteAllNotificationApi = baseUrl + "/Pharmacy/DeleteAllNotification"
