// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// No records to display, check back soon!
  public static let commonEmptyStateDes = L10n.tr("Localizable", "common_emptyState_des", fallback: "No records to display, check back soon!")
  /// No data yet.
  public static let commonEmptyStateTitle = L10n.tr("Localizable", "common_emptyState_title", fallback: "No data yet.")
  /// Please update new version
  public static let commonForceUpdateStateDes = L10n.tr("Localizable", "common_forceUpdateState_des", fallback: "Please update new version")
  /// Next time
  public static let commonForceUpdateStateNextTimeBtn = L10n.tr("Localizable", "common_forceUpdateState_nextTimeBtn", fallback: "Next time")
  /// New version is available
  public static let commonForceUpdateStateTitle = L10n.tr("Localizable", "common_forceUpdateState_title", fallback: "New version is available")
  /// Type to search
  public static let commonSearchPlaceholder = L10n.tr("Localizable", "common_search_placeholder", fallback: "Type to search")
  /// ADD CONTACT DETAILS
  public static let contactAddContactTitle = L10n.tr("Localizable", "contact_addContact_title", fallback: "ADD CONTACT DETAILS")
  /// Service is temporarily unavailable. Please try again or contact your System Administrator for further assistance.
  public static let errorCommonUnavailable = L10n.tr("Localizable", "error_common_unavailable", fallback: "Service is temporarily unavailable. Please try again or contact your System Administrator for further assistance.")
  /// Favorite
  public static let titleScreenFavorite = L10n.tr("Localizable", "title_screen_favorite", fallback: "Favorite")
  /// Movie
  public static let titleScreenMovie = L10n.tr("Localizable", "title_screen_movie", fallback: "Movie")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
