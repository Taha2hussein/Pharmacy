//
//  BaseURL.swift
//  MachhineTest
//
//  Created by A on 24/12/2021.
//

import Foundation
let baseUrl = "https://e4clinicdevapi.ekadsoft.org/api"
let baseURLImage = "https://e4clinicdevapi.ekadsoft.org/"
let login = baseUrl + "login"
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
