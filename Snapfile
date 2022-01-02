# A list of devices you want to take the screenshots from
devices([
    "iPhone 13 Pro",
    "iPhone 8 Plus",
    # "iPad Pro (12.9-inch) (5th generation)"
])

languages([
  "en-US",
  "de-DE",
  "ja",
  "ru",
  "zh-Hans"
])

# The name of the scheme which contains the UI Tests
scheme("Screenshots")

# Where should the resulting screenshots be stored?
output_directory("./appstore_screenshots")

# remove the '#' to clear all previously generated screenshots before creating new ones
clear_previous_screenshots(true)

# Remove the '#' to set the status bar to 9:41 AM, and show full battery and reception. See also override_status_bar_arguments for custom options.
override_status_bar(true)

# Arguments to pass to the app on launch. See https://docs.fastlane.tools/actions/snapshot/#launch-arguments
launch_arguments(["--uitesting"])

# For more information about all available options run
# fastlane action snapshot
