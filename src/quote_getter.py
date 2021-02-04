import robin_stocks as rs
import os 

def login(username=None, password=None, expiresIn=86400, sms=True):
    if not username:
        robin_user = os.environ.get("robinhood_username")
    if not password:
        robin_pass = os.environ.get("robinhood_password")
    rs.login(username=robin_user,
            password=robin_pass,
            expiresIn=expiresIn,
            by_sms=sms)

def logout():
    rs.logout()
        


def main():
    login()
    info = rs.stocks.get_stock_quote_by_symbol('IPOF')
    info = rs.stocks.get_stock_quote_by_symbol('IPOZ')

    logout()

    


    

if __name__ == "__main__":
    main()
