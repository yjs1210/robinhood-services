import robin_stocks as r
import os 

def login(username=None, password=None, expiresIn=86400, sms=True):
    if not username:
        robin_user = os.environ.get("robinhood_username")
    if not password:
        robin_pass = os.environ.get("robinhood_password")
    r.login(username=robin_user,
            password=robin_pass,
            expiresIn=expiresIn,
            by_sms=sms)
    print('hi')

def get_quote(symbol):
    assert isinstance(symbol, str)
    info = rs.stocks.get_stock_quote_by_symbol(symbol)
    return info

def check_balance():
    pass

def order_by_dollars(symbol, ammountInDollars)
    rs.orders.order_buy_fractional_by_price(symbol,
                                       ammountInDollars,
                                       timeInForce='gtc',
                                       extendedHours=False) 

def logout():
    rs.logout()