# Forex Watchlist

## Major Pairs (Track Daily)

| Pair   | Name                     | Notes                          |
|--------|--------------------------|--------------------------------|
| EURUSD | Euro / US Dollar         | Most liquid pair worldwide     |
| GBPUSD | British Pound / US Dollar| Higher volatility than EUR     |
| USDJPY | US Dollar / Japanese Yen | Asian session active           |
| USDCHF | US Dollar / Swiss Franc  | Safe-haven correlation with gold|

## Cross Pairs (Track Weekly — Phase 2)

| Pair   | Name                     | Notes                          |
|--------|--------------------------|--------------------------------|
| EURGBP | Euro / British Pound     | Low volatility, range-bound    |
| EURJPY | Euro / Japanese Yen      | Higher volatility cross        |

## Budget

- 4 major pairs × 1 daily candle pull = 4 API calls per session
- Morning + evening = 8 calls/day (Phase 1 uses morning only = 4 calls)
- Remaining budget: 21 calls/day for on-demand analysis
