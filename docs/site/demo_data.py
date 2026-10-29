# 오늘의 주접 체험 데이터: 앱의 Quotes.xcstrings · Localizable.xcstrings 에서 그 언어의 주접과 기분 이름을 그대로 가져와 <code>.json 의 demo 에 넣는다.
# 쓰는 법: python3 docs/site/demo_data.py . 다음에 sitegen.py 를 다시 돌린다.
import json, re, sys, glob, os
repo = sys.argv[1]
src = open(f"{repo}/Jujob/Managers/QuotesManager.swift").read()
pairs = re.findall(r'String\(localized: "(quote\.\d+)", defaultValue: "((?:[^"\\]|\\.)*)", table: "Quotes"\), category: \.(\w+)', src)
assert len(pairs) == 281, len(pairs)
Q = json.load(open(f"{repo}/Jujob/Quotes.xcstrings"))["strings"]
L = json.load(open(f"{repo}/Jujob/Localizable.xcstrings"))["strings"]
moods = [("morning", "아침", "🌅"), ("commute", "출근길", "🚶"), ("tough", "힘들때", "💪"),
         ("beforeInterview", "면접전", "👔"), ("beforeDate", "데이트전", "💕"), ("afterWork", "퇴근길", "🏠")]
def loc(entry, code, fallback):
    v = entry.get("localizations", {}).get(code, {}).get("stringUnit", {}).get("value")
    return v if v else fallback
for path in sorted(glob.glob(f"{repo}/docs/site/*.json")):
    code = os.path.basename(path)[:-5]
    if code == "site": continue
    d = json.load(open(path))
    quotes = [loc(Q.get(k, {}), code, dv.encode().decode("unicode_escape") if code == "ko" else None) for k, dv, _ in pairs]
    if code == "ko":
        quotes = [json.loads('"' + dv + '"') for _, dv, _ in pairs]
    assert all(quotes), code
    cats = [c for _, _, c in pairs]
    d["demo"]["moods"] = [{"emoji": e, "name": loc(L[k], code, k) if code != "ko" else k, "first": cats.index(m)} for m, k, e in moods]
    d["demo"]["quotes"] = quotes
    open(path, "w").write(json.dumps(d, ensure_ascii=False, indent=2) + "\n")
    print(code, len(quotes))
