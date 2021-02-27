import database as db
import robinstocks_wrapper as rs 
import datetime 
from enum import Enum


class SQLVars(str, Enum):
    DATABASE = 'SPACs.sqlite'
    TICKERS = "existing_tickers"

class TickersColumns(str, Enum):
    TICKER = "ticker"
    FIRST_OCCURENCE_DATE = "first_dt"

def getIndexOfEnum(val, enum):
    return [i.value for i in enum].index(val)

def main():
    rs.login()
    conn = db.db_connect(SQLVars.DATABASE.value)
    exists = db.check_if_table_exists(conn, SQLVars.TICKERS.value)
    if not exists:
        sql_create_tickers_table = """ CREATE TABLE IF NOT EXISTS existing_tickers (
            ticker text,
            first_dt text 
        ) """
        db.execute_query(conn, sql_create_tickers_table)

    current_symbols =  db.get_col_from_table(conn, TickersColumns.TICKER.value, SQLVars.TICKERS.value)
    current_symbols = [i[getIndexOfEnum('ticker', TickersColumns)] for i in current_symbols]
    stocks_to_check = [ 'IPO' + chr(i + ord('a')).upper() for i in range(26)]
    stocks_to_check_filtered = list(set(stocks_to_check)  - set(current_symbols))
    curr_date = datetime.datetime.today().strftime('%Y-%m-%d')
    new_tickers = []
    for symbol in stocks_to_check_filtered:
        quotes = rs.get_quote(symbol)
        if quotes:
            new_tickers.append((symbol, curr_date))
            order_by_dollars(symbol, 1000)
    
    db.insert_into_table(conn, SQLVars.TICKERS.value, new_tickers)
    rs.logout()

if __name__ == "__main__":
    main()
