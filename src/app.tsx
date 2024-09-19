import { Hono } from "hono";
import { html } from "hono/html";
import { serveStatic } from "@hono/node-server/serve-static";
import { swaggerUI } from "@hono/swagger-ui";
import leagues from "./services/leagues";
import teams from "./services/teams";
import Layout from "./views/layout";
import { swaggerDoc } from "../doc/swaggerDoc";

const app = new Hono();

// static files
app.use("/src/public/*", serveStatic({ root: "./" }));

// api documentation
app.get("/doc", (c) => c.json(swaggerDoc));
app.get("/ui", swaggerUI({ url: "/doc" }));

// routes
app.get("/", (c) => c.html(html`<!doctype html>${(<Layout />)}`));
app.route("api/v1/leagues", leagues);
app.route("api/v1/teams", teams);

export default app;
