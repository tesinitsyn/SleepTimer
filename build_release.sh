#
//  build_release.sh
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 15.03.2025.
//

SCHEME='SleepTimer'

set -o pipefail && xcodebuild -configuration Release -scheme <YourScheme> -sdk macosx -destination 'platform=macOS' CODE_SIGNING_ALLOWED='NO'
