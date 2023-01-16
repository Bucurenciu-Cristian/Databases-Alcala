import psycopg2

def connect():
    try:
        host = input("Enter host: ")
        port = input("Enter port: ")
        user = input("Enter user: ")
        password = input("Enter password: ")
        database = input("Enter database: ")
        conn = psycopg2.connect(host=host, port=port, user=user, password=password, database=database)
        return conn
    except psycopg2.OperationalError as e:
        print(f"Error connecting to the database: {e}")
    except psycopg2.ProgrammingError as e:
        print(f"Error in SQL query: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
    conn = connect()
    if conn:
        cursor = conn.cursor()
        
        while True:
            print("1. Select full_name from cal2.people, cal2.actors and cal2.directors")
            print("2. Select name, title from cal2.actors, cal2.directors, cal2.movies and cal2.people")
            print("3. Insert first a movie, then a review for the movie")
            print("4. Exit")

            choice = input("Enter your choice: ")

            if choice == "1":
                try:
                    cursor.execute("SELECT full_name FROM cal2.people A JOIN cal2.actors B ON A.full_name = B.name JOIN cal2.directors C ON A.full_name = C.name;")
                    result = cursor.fetchall()
                    for row in result:
                        print(row)
                except psycopg2.ProgrammingError as e:
                    print(f"Error in SQL query: {e}")
                except Exception as e:
                    print(f"An error occurred: {e}")
            elif choice == "2":
                try:
                    cursor.execute("SELECT A.name, M.title FROM cal2.actors A JOIN cal2.directors D ON A.name = D.name JOIN cal2.movies M ON D.name = M.director JOIN cal2.people P on A.person = P.full_name and D.person = P.full_name;")
                    result = cursor.fetchall()
                    for row in result:
                        print(row)
                except psycopg2.ProgrammingError as e:
                    print(f"Error in SQL query: {e}")
                except Exception as e:
                    print(f"An error occurred: {e}")
            elif choice == "3":
                try:
                    year = input("Enter year: ")
                    title = input("Enter title: ")
                    runtime = input("Enter runtime: ")
                    language = input("Enter Language: ")
                    author = input("Enter Author: ")
                    reviewContent = input("Enter Review: ")
                    site = input("Enter website: ")
                    hash = input("Enter the hash: ")
                    rating = input("Enter please a rating: ")
                    cursor.execute(f"INSERT INTO cal2.movies (year, title, runtime, language) VALUES ({year}, '{title}', {runtime}, '{language}');")
                    cursor.execute(f"INSERT INTO cal2.reviews (year, title, author, content, site, hash, rating) VALUES ({year}, '{title}', '{author}', '{reviewContent}', '{site}', '{hash}', {rating});")
                    conn.commit()
                    print("Movie inserted successfully.")
                except psycopg2.ProgrammingError as e:
                    print(f"Error in SQL query: {e}")
                except Exception as e:
                    print(f"An error occurred: {e}")
            elif choice == "4":
                cursor.close()
                conn.close()
                break
            else:
                print("Invalid choice.")

if __name__ == "__main__":
    main()
               
