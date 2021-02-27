import os 
import sqlite3

def db_connect(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except Error as e:
        print(e)

    return conn

def execute_query(conn, query):
    """ 
    Executes a sql query
    """
    try:
        curr = conn.cursor()
        curr.execute(query)
    except Error as e:
        print(e)

def check_if_table_exists(conn, table_nm):
    query = """ SELECT name FROM sqlite_master WHERE type='table' AND name= ?"""
    try:
        curr = conn.cursor()
        curr.execute(query, [table_nm])
        return len(curr.fetchall()) == 1 
    except Error as e:
        print(e)


def get_col_from_table(conn, col, table):
    query = """ select {} from {} """.format(col, table)
    try:
        curr = conn.cursor()
        curr.execute(query)
        return curr.fetchall()
    except Error as e:
        print(e)


def insert_into_table(conn, table, values):
    query = """ insert into {} values (?,?) """.format(table)
    try:
        curr = conn.cursor()
        for item in values:
            curr.execute(query, item)
        conn.commit()
    except Error as e:
        print(e)


def check_if_exists(symbol, conn, table):
    pass    


def db_disconnect(conn):
    conn.close()
