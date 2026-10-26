#!/bin/sh
# 배포 전 게이트 — 여기서 실패하면 DeployBar 가 아카이브를 만들지 않는다.
#
# 사용법:
#   sh scripts/predeploy.sh
#
# 다국어(.xcstrings) 검사는 DeployBar 에 내장돼 있으므로 여기서 다시 하지 않는다.
# 이 앱에는 테스트 타겟이 없어서 테스트 단계는 없다. 대신 버전 단일 소스와 Release 빌드를 본다.
#
# ⚠️ CODE_SIGNING_ALLOWED=NO 로 빌드를 빠르게 만들지 말 것.
#    entitlements 가 빠지면 CloudKit 등 실제 배포 경로에서만 터지는 문제를 놓친다.
set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

SCHEME="Jujob"
PROJECT="Jujob.xcodeproj"
VERSION_XCCONFIG="Config/Version.xcconfig"

# ── 1. 버전이 한 곳에만 있는지 ───────────────────────────────────────────
# 타겟 빌드 설정(project.pbxproj)에 MARKETING_VERSION 이 다시 박히면 그게
# Version.xcconfig 를 이긴다. xcconfig 만 올려도 조용히 옛 버전이 올라가므로
# pbxproj 에 남은 값이 xcconfig 와 다르면 여기서 멈춘다.
echo "🔢 [1/2] 버전 단일 소스 확인"
if [ ! -f "$VERSION_XCCONFIG" ]; then
  echo "❌ $VERSION_XCCONFIG 가 없습니다 — deploy.env 의 VERSION_XCCONFIG 와 어긋납니다"
  exit 1
fi
XC_VERSION="$(sed -n 's/^[[:space:]]*MARKETING_VERSION[[:space:]]*=[[:space:]]*\([^[:space:]]*\).*/\1/p' "$VERSION_XCCONFIG" | head -1)"
XC_BUILD="$(sed -n 's/^[[:space:]]*CURRENT_PROJECT_VERSION[[:space:]]*=[[:space:]]*\([^[:space:]]*\).*/\1/p' "$VERSION_XCCONFIG" | head -1)"
if [ -z "$XC_VERSION" ] || [ -z "$XC_BUILD" ]; then
  echo "❌ $VERSION_XCCONFIG 에 MARKETING_VERSION / CURRENT_PROJECT_VERSION 이 없습니다"
  exit 1
fi
for KEY in MARKETING_VERSION CURRENT_PROJECT_VERSION; do
  case "$KEY" in
    MARKETING_VERSION) WANT="$XC_VERSION" ;;
    *)                 WANT="$XC_BUILD" ;;
  esac
  ODD="$(grep -E "^[[:space:]]*$KEY = " "$PROJECT/project.pbxproj" \
         | sed 's/.*= *//; s/;.*//' | sort -u | grep -vx "$WANT" || true)"
  if [ -n "$ODD" ]; then
    echo "❌ $KEY 가 어긋납니다 — $VERSION_XCCONFIG 는 '$WANT' 인데"
    echo "   project.pbxproj 에 다음 값이 남아 있습니다:"
    echo "$ODD" | sed 's/^/     /'
    echo "   pbxproj 의 값을 지워 xcconfig 하나만 남겨 주세요"
    exit 1
  fi
done
echo "   $XC_VERSION ($XC_BUILD)"

# ── 2. Release 빌드가 서는지 ────────────────────────────────────────────
# 아카이브가 Release 로 지어지므로 Release 로 확인한다.
# generic 시뮬레이터 대상이라 시뮬레이터를 띄우지 않는다.
echo "🔨 [2/2] Release 빌드 ($SCHEME · 위젯 확장 포함)"
xcodebuild build \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -quiet

echo ""
echo "✅ 게이트 통과 — 배포 가능"
