//  build_release.sh
//  SleepTimer
//
//  Created by Timofey Sinitsyn on 15.03.2025.
//
#!/bin/bash


SCHEME='SleepTimer'

set -o pipefail && xcodebuild -configuration Release -scheme $SCHEME -sdk macosx -destination 'platform=macOS' CODE_SIGNING_ALLOWED='NO'
