//
//  String+Localized.swift
//  Rankeet
//
//  Created by Alejandro Hernández Matías on 26/5/18.
//  Copyright © 2018 Rankeet. All rights reserved.
//

import UIKit

import Foundation

func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

//MARK: Tabs Screen
extension String {
    static let tabs_1 = NSLocalizedString("tabs_1")
    static let tabs_2 = NSLocalizedString("tabs_2")
    static let tabs_3 = NSLocalizedString("tabs_3")
    static let tabs_4 = NSLocalizedString("tabs_4")
    
    //Generic Screen
    static let generic_error = NSLocalizedString("generic_error")
    static let generic_accept = NSLocalizedString("generic_accept")
    static let generic_cancel = NSLocalizedString("generic_cancel")
    static let generic_and = NSLocalizedString("generic_and")
    
    
    //Facilities Screen
    static let facilities_message_location_title = NSLocalizedString("facilities_message_location_title")
    static let facilities_message_location_message = NSLocalizedString("facilities_message_location_message")
    static let facilities_message_location_button_yes = NSLocalizedString("facilities_message_location_button_yes")
    static let facilities_message_location_button_later = NSLocalizedString("facilities_message_location_button_later")
    static let facilities_error_message = NSLocalizedString("facilities_error_message")
    
    static let facilities_farway_dialog_title = NSLocalizedString("facilities_farway_dialog_title")
    static let facilities_farway_dialog_message = NSLocalizedString("facilities_farway_dialog_message")
    static let facilities_error_location_dialog_title = NSLocalizedString("facilities_error_location_dialog_title")
    static let facilities_error_location_dialog_message = NSLocalizedString("facilities_error_location_dialog_message")
    
    //ChangeLocation Screen
    static let change_location_error_message = NSLocalizedString("change_location_error_message")
    
    //Facility cells
    static let facility_cell_typology_Rankeet_lighting_on = NSLocalizedString("facility_cell_typology_Rankeet_lighting_on")
    static let facility_cell_typology_Rankeet_lighting_off = NSLocalizedString("facility_cell_typology_Rankeet_lighting_off")
    static let facility_cell_typology_no_Rankeet = NSLocalizedString("facility_cell_typology_no_Rankeet")
    static let facility_cell_distance_prefix = NSLocalizedString("facility_cell_distance_prefix")
    static let facilities_no_location_reminder = NSLocalizedString("facilities_no_location_reminder")
    
    //Facility detail
    static let facility_detail_select_field = NSLocalizedString("facility_detail_select_field")
    static let facility_detail_until_time = NSLocalizedString("facility_detail_until_time")
    static let facility_detail_select_hour = NSLocalizedString("facility_detail_select_hour")
    static let facility_detail_select_see_map = NSLocalizedString("facility_detail_select_see_map")
    static let facility_detail_lighting_action = NSLocalizedString("facility_detail_lighting_action")
    
    static let facility_detail_state_not_available = NSLocalizedString("facility_detail_state_not_available")
    static let facility_detail_state_booked = NSLocalizedString("facility_detail_state_booked")
    static let facility_detail_state_available = NSLocalizedString("facility_detail_state_available")
    static let facility_detail_state_available_turn_on = NSLocalizedString("facility_detail_state_available_turn_on")
    
    static let facility_route_question_title = NSLocalizedString("facility_route_question_title")
    static let facility_route_question_message = NSLocalizedString("facility_route_question_message")
    static let facility_route_question_first_button = NSLocalizedString("facility_route_question_first_button")
    static let facility_route_question_second_button = NSLocalizedString("facility_route_question_second_button")
    
    static let facility_sport_selection_any_sport = NSLocalizedString("facility_sport_selection_any_sport")
    
    
    //Sports detail
    static let bookings_free_reservation = NSLocalizedString("bookings_free_reservation")
    static let bookings_error_action_title = NSLocalizedString("bookings_error_action_title")
    static let bookings_error_action_message = NSLocalizedString("bookings_error_action_message")
    
    static let bookings_wallet_money = NSLocalizedString("bookings_wallet_money")
    static let bookings_summary_price = NSLocalizedString("bookings_summary_price")
    
    static let bookings_remains = NSLocalizedString("bookings_remains")
    static let bookings_hours = NSLocalizedString("bookings_hours")
    static let bookings_mins = NSLocalizedString("bookings_mins")
    
    static let bookings_from = NSLocalizedString("bookings_from")
    static let bookings_to = NSLocalizedString("bookings_to")
    
    static let bookings_section_actives = NSLocalizedString("bookings_section_actives")
    static let bookings_section_older = NSLocalizedString("bookings_section_older")
    
    static let bookings_cancel_title = NSLocalizedString("bookings_cancel_title")
    static let bookings_cancel_message = NSLocalizedString("bookings_cancel_message")
    
    static let bookings_detail_switch_off_message = NSLocalizedString("bookings_detail_switch_off_message")
    static let bookings_detail_switch_off_option_1 = NSLocalizedString("bookings_detail_switch_off_option_1")
    static let bookings_detail_switch_off_option_2 = NSLocalizedString("bookings_detail_switch_off_option_2")
    static let bookings_detail_switch_off_option_3 = NSLocalizedString("bookings_detail_switch_off_option_3")
    static let bookings_detail_switch_off_option_4 = NSLocalizedString("bookings_detail_switch_off_option_4")
    static let bookings_detail_switch_off_option_5 = NSLocalizedString("bookings_detail_switch_off_option_5")
    
    static let bookings_turn_off_title = NSLocalizedString("bookings_turn_off_title")
    static let bookings_turn_off_message = NSLocalizedString("bookings_turn_off_message")
    
    static let bookings_extend_title = NSLocalizedString("bookings_extend_title")
    static let bookings_extend_message = NSLocalizedString("bookings_extend_message")
    
    static let bookings_generic_error_title = NSLocalizedString("bookings_generic_error_title")
    static let bookings_generic_error_message = NSLocalizedString("bookings_generic_error_message")
    
    static let bookings_extend_message_error = NSLocalizedString("bookings_extend_message_error")
    
    static let facility_detail_now = NSLocalizedString("facility_detail_now")
    
    //Bookings
    static let sport_type_0 = NSLocalizedString("sport_type_0")
    static let sport_type_1 = NSLocalizedString("sport_type_1")
    static let sport_type_2 = NSLocalizedString("sport_type_2")
    static let sport_type_3 = NSLocalizedString("sport_type_3")
    static let sport_type_4 = NSLocalizedString("sport_type_4")
    static let sport_type_5 = NSLocalizedString("sport_type_5")
    static let sport_type_6 = NSLocalizedString("sport_type_6")
    static let sport_type_7 = NSLocalizedString("sport_type_7")
    static let sport_type_8 = NSLocalizedString("sport_type_8")
    static let sport_type_9 = NSLocalizedString("sport_type_9")
    static let sport_type_10 = NSLocalizedString("sport_type_10")
    static let sport_type_11 = NSLocalizedString("sport_type_11")
    static let sport_type_12 = NSLocalizedString("sport_type_12")
    static let sport_type_13 = NSLocalizedString("sport_type_13")
    static let sport_type_14 = NSLocalizedString("sport_type_14")
    static let sport_type_15 = NSLocalizedString("sport_type_15")
    static let sport_type_16 = NSLocalizedString("sport_type_16")
    static let sport_type_17 = NSLocalizedString("sport_type_17")
    static let sport_type_18 = NSLocalizedString("sport_type_18")
    static let sport_type_19 = NSLocalizedString("sport_type_19")
    static let sport_type_20 = NSLocalizedString("sport_type_20")
    static let sport_type_21 = NSLocalizedString("sport_type_21")
    static let sport_type_123 = NSLocalizedString("sport_type_123")
    static let sport_type_456 = NSLocalizedString("sport_type_456")
    
    static let bookings_cancel_action = NSLocalizedString("bookings_cancel_action")
    static let bookings_switchof_action = NSLocalizedString("bookings_switchof_action")
    static let bookings_extend_action = NSLocalizedString("bookings_extend_action")
    
    static let bookings_detail_action_cancel = NSLocalizedString("bookings_detail_action_cancel")
    static let bookings_detail_action_extend = NSLocalizedString("bookings_detail_action_extend")
    static let bookings_detail_action_add_issue = NSLocalizedString("bookings_detail_action_add_issue")
    static let bookings_detail_action_book_again = NSLocalizedString("bookings_detail_action_book_again")
    static let bookings_detail_action_turn_off = NSLocalizedString("bookings_detail_action_turn_off")
    
    static let bookings_detail_state_finished = NSLocalizedString("bookings_detail_state_finished")
    static let bookings_detail_state_cancelled = NSLocalizedString("bookings_detail_state_cancelled")
    static let bookings_detail_state_in_progress = NSLocalizedString("bookings_detail_state_in_progress")
    
    static let issues_message = NSLocalizedString("issues_message")
    static let issues_action = NSLocalizedString("issues_action")
    static let issues_title = NSLocalizedString("issues_title")
    
    static let issues_title_error = NSLocalizedString("issues_title_error")
    static let issues_message_error = NSLocalizedString("issues_message_error")
    static let issues_message_ok = NSLocalizedString("issues_message_ok")
    
    static let profile_logout_title = NSLocalizedString("profile_logout_title")
    static let profile_logout_message = NSLocalizedString("profile_logout_message")
    
    static let login_confirmation_message = NSLocalizedString("login_confirmation_message")
    
    static let login_error_verification_title = NSLocalizedString("login_error_verification_title")
    static let login_error_verification_message = NSLocalizedString("login_error_verification_message")
    
    static let login_ok_verification_title = NSLocalizedString("login_ok_verification_title")
    static let login_ok_verification_message = NSLocalizedString("login_ok_verification_message")
    
    static let login_reset_password_title = NSLocalizedString("login_reset_password_title")
    static let login_reset_password_message = NSLocalizedString("login_reset_password_message")
    
    static let login_reset_password_error_title = NSLocalizedString("login_reset_password_error_title")
    static let login_reset_password_error_message = NSLocalizedString("login_reset_password_error_message")
    
    static let profile_change_password_title = NSLocalizedString("profile_change_password_title")
    static let profile_change_password_message = NSLocalizedString("profile_change_password_message")
    static let recharge_select_payment_method_message = NSLocalizedString("recharge_select_payment_method_message")
    static let recharge_select_payment_method_no_card = NSLocalizedString("recharge_select_payment_method_no_card")
    static let recharge_select_payment_method_button = NSLocalizedString("recharge_select_payment_method_button")
    
    static let recharge_message_dialog_error_message_1 = NSLocalizedString("recharge_message_dialog_error_message_1")
    static let recharge_message_dialog_error_message_2 = NSLocalizedString("recharge_message_dialog_error_message_2")
    static let recharge_message_dialog_cancel_message = NSLocalizedString("recharge_message_dialog_cancel_message")
    static let recharge_message_dialog_ok_message = NSLocalizedString("recharge_message_dialog_ok_message")
    
    static let recharge_message_dialog_error_title = NSLocalizedString("recharge_message_dialog_error_title")
    static let recharge_message_dialog_cancel_title = NSLocalizedString("recharge_message_dialog_cancel_title")
    static let recharge_message_dialog_ok_title = NSLocalizedString("recharge_message_dialog_ok_title")
    
    static let recharge_message_confirm_title = NSLocalizedString("recharge_message_confirm_title")
    static let recharge_message_confirm_message = NSLocalizedString("recharge_message_confirm_message")
    static let recharge_message_confirm_message_2 = NSLocalizedString("recharge_message_confirm_message_2")
}
