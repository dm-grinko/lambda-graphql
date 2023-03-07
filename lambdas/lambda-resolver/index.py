import json

books = [
        {
            "title": 'The Awakening',
            "author": 'Kate Chopin',
        },
        {
            "title": 'City of Glass',
            "author": 'Paul Auster',
        }
    ]

def getBookByAuthor(books, author):
    for b in books:
        if b["author"] == author:
            return b
    else:
        return None

def getBookByTitle(books, title):
    for b in books:
        if b["title"] == title:
            return b
    else:
        return None

def handler(event, context):
    print('event', event)

    switcher = {
        "getAllBooks": books,
        "getBookByAuthor": getBookByAuthor(books, event["arg"]),
        "getBookByTitle": getBookByTitle(books, event["arg"]),
    }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(
            switcher.get(event["query"], "nothing")
        )
    }
