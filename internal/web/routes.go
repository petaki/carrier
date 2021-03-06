package web

import (
	"net/http"

	"github.com/justinas/alice"
)

func (app *app) routes() http.Handler {
	baseMiddleware := alice.New(app.recoverPanic)
	webMiddleware := alice.New(
		app.inertiaManager.Middleware,
	)

	mux := http.NewServeMux()
	mux.Handle("/", webMiddleware.ThenFunc(app.cpuIndex))
	mux.Handle("/memory", webMiddleware.ThenFunc(app.memoryIndex))
	mux.Handle("/disk", webMiddleware.ThenFunc(app.diskIndex))

	fileServer := http.FileServer(http.Dir("./public/"))

	mux.Handle("/css/", fileServer)
	mux.Handle("/images/", fileServer)
	mux.Handle("/js/", fileServer)
	mux.Handle("/favicon.ico", fileServer)

	return baseMiddleware.Then(mux)
}
