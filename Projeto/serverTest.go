package main

import "database/sql"
import _ "github.com/go-sql-driver/mysql"

import "golang.org/x/crypto/bcrypt"

import "net/http"

// Allows you to pass values between functions
// Such as an error message
// https://golang.org/pkg/context/
import "context"

// Use templates to add custom values
// Such as an error message
// https://golang.org/pkg/html/template/
import "html/template"

//import "github.com/gorilla/mux"

import "fmt"

// Caches all the templates from the views folder int the value views
// The full path to the views folder
var views = template.Must(template.ParseGlob("C:/Users/Edson/Documents/GitHub/GoLangExercicios/Projeto/html/view/*.html"))

// Used by context
type key int

const MyKey key = 0

// Error messages will be type struct for context to pass around
type loginerror struct {
	// And the message is stored as a string
	// Skip down to the next comment
	Err string
}

type heroi struct {
	Username string
	HeroiID  int
	Nome     string
}
type selectHero struct {
	Username     string
	Nome         string
	Codinome     string
	Idade        string
	Planeta      string
	Descricao    string
	Nivel        string
	Raca         string
	Classe       string
	Forca        int
	Constituicao int
	Destreza     int
	Agilidade    int
	Inteligencia int
	ForcaVontade int
	Percepcao    int
	Carisma      int
}

var hero heroi
var heroes []heroi
var selHer selectHero
var selHes []selectHero

var db *sql.DB
var err error

var username string

func signupPage(res http.ResponseWriter, req *http.Request) {
	if req.Method != "POST" {
		http.ServeFile(res, req, "html/signup.html")
		return
	}

	username := req.FormValue("username")
	password := req.FormValue("password")
	var user string

	err := db.QueryRow("SELECT username FROM users WHERE username=?", username).Scan(&user)

	switch {
	case err == sql.ErrNoRows:
		//trecho de codigo destinado a implementar criptografia
		//hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
		/*
			if err != nil {
				http.Error(res, "Server error, unable to create your account.\n problema to crypto", 500)
				return
			}
		*/

		_, err = db.Exec("CALL InsertUser(?, ?)", username, password)
		if err != nil {
			http.Error(res, "Server error, unable to create your account.\nProblem to insert on database", 500)
			return
		}

		res.Write([]byte("User created!"))
		return
	case err != nil:
		http.Error(res, "Server error, unable to create your account.3", 500)
		return
	default:
		http.Redirect(res, req, "/", 301)
	}
}

// This function gets called if a login error occurs
func login(res http.ResponseWriter, req *http.Request) {
	// grab the context value (the message)
	// le short for login error
	le, _ := req.Context().Value(MyKey).(loginerror)
	// send the user the login template with the error message
	views.ExecuteTemplate(res, "index", loginerror{le.Err})
}

func loginHero(res http.ResponseWriter, req *http.Request) {
	le, _ := req.Context().Value(MyKey).(loginerror)
	views.ExecuteTemplate(res, "userPage", loginerror{le.Err})
}

func loginPage(res http.ResponseWriter, req *http.Request) {
	if req.Method != "POST" {
		http.ServeFile(res, req, "html/login.html")
		return
	}

	username = req.FormValue("username")
	password := req.FormValue("password")
	fmt.Println(username)
	fmt.Println(password)
	var databaseUsername string
	var databasePassword string

	err := db.QueryRow("SELECT username, password FROM users WHERE username=?", username).Scan(&databaseUsername, &databasePassword)

	// uh oh error! let's tell the user
	if err != nil {
		// Create the error message
		le := loginerror{"No user with that username!"}
		// Put it in a context
		ctx := context.WithValue(req.Context(), MyKey, le)
		// Pass it to the login function
		login(res, req.WithContext(ctx))
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(databasePassword), []byte(password))
	if err != nil {
		rows, err := db.Query(" CALL SelectUserHeroi(?)", username)
		if err != nil {
			return
		}
		defer rows.Close()
		for rows.Next() {
			err = rows.Scan(&hero.Username, &hero.HeroiID, &hero.Nome)

			heroes = append(heroes, hero)
		}
		err = rows.Err()

		fmt.Println(heroes)

		http.Redirect(res, req, "/loged", 301)

		return
	}

	http.Redirect(res, req, "html/index.html", 301)

	res.Write([]byte("Hello" + databaseUsername))
}

func homePage(res http.ResponseWriter, req *http.Request) {
	http.ServeFile(res, req, "html/index.html")
}

func SVGPage(res http.ResponseWriter, req *http.Request) {
	http.ServeFile(res, req, "html/sgv.html")
}

func SVGChartsPage(res http.ResponseWriter, req *http.Request) {
	http.ServeFile(res, req, "html/svgCharts.html")
}

func VuePage(res http.ResponseWriter, req *http.Request) {
	http.ServeFile(res, req, "html/vue.html")
}

func HeadPage(res http.ResponseWriter, req *http.Request) {
	http.ServeFile(res, req, "html/header.html")
}

func logedPage(res http.ResponseWriter, req *http.Request) {
	if req.Method != "POST" {
		t, _ := template.ParseFiles("html/view/userPage.html")
		t.Execute(res, heroes)
		heroes = heroes[:0]
		return
	}
	HeroiID := req.FormValue("IDHero")
	fmt.Println(HeroiID)
	/*
		if req.Method != "POST" {
			http.ServeFile(res, req, "html/view/userPage.html")
			return
		}

		rows, err := db.Query(" CALL selectStatus(?)", username)
		if err != nil {
			return
		}
		defer rows.Close()
		for rows.Next() {
			err = rows.Scan(&stat.Forca, &stat.Constituicao, &stat.Destreza, &stat.Agilidade, &stat.Inteligencia, &stat.ForcaVontade, &stat.Percepcao, &stat.Carisma)

		}
		err = rows.Err()

		http.Redirect(res, req, "/loged/Hero", 301)
	*/

}

func heroPage(res http.ResponseWriter, req *http.Request) {
	HeroiID := req.FormValue("IDHero")
	fmt.Println("'" + HeroiID + "'")

	rows, err := db.Query(" CALL SelectHeroi(?)", HeroiID)
	if err != nil {
		return
	}

	defer rows.Close()
	for rows.Next() {
		err = rows.Scan(&selHer.Username, &selHer.Nome, &selHer.Codinome, &selHer.Idade, &selHer.Planeta, &selHer.Descricao, &selHer.Nivel, &selHer.Raca, &selHer.Classe, &selHer.Forca, &selHer.Constituicao, &selHer.Destreza, &selHer.Agilidade, &selHer.Inteligencia, &selHer.ForcaVontade, &selHer.Percepcao, &selHer.Carisma)

		selHes = append(selHes, selHer)

	}
	err = rows.Err()
	fmt.Println(selHes)

	//http.Redirect(res, req, "/loged/hero", 301)
	//funcao que serve para passar variaveis para pagina HTML
	t, _ := template.ParseFiles("html/view/status.html")

	t.Execute(res, selHes)
	selHes = selHes[:0]
	//http.ServeFile(res, req, "html/view/template1.html")
}

func main() {

	db, err = sql.Open("mysql", "root:1234@/RPG")
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		panic(err.Error())
	}

	//r := mux.NewRouter()
	//http.Handle("/", r)

	http.HandleFunc("/vue", VuePage)
	http.HandleFunc("/sgv", SVGPage)
	http.HandleFunc("/svgCharts", SVGChartsPage)
	http.HandleFunc("/head", HeadPage)

	http.HandleFunc("/signup", signupPage)
	http.HandleFunc("/login", loginPage)
	http.HandleFunc("/", homePage)

	http.HandleFunc("/loged", logedPage)
	http.HandleFunc("/loged/hero", heroPage)
	http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))

	http.ListenAndServe(":8080", nil)
}
