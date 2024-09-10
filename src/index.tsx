import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { html } from "hono/html";
import { serveStatic } from "@hono/node-server/serve-static";
import { swaggerUI } from "@hono/swagger-ui";
import leagues from "./services/leagues";
//import teams from "./services/teams";
import Layout from "./views/layout";
import { leaguesDoc } from "./doc/leaguesDoc";
import { swaggerBase } from "./doc/swaggerBase";

const app = new Hono();
const port = 3000;

// static files
app.use("/src/public/*", serveStatic({ root: "./" }));

// api documentation
const swaggerDoc = {
  ...swaggerBase,
  paths: {
    ...leaguesDoc,
  },
};

app.get('/doc', (c) => c.json(swaggerDoc));
app.get("/ui", swaggerUI({ url: "/doc" }));

// routes
app.get("/", (c) => c.html(html`<!doctype html>${(<Layout />)}`));
app.route("api/v1/leagues", leagues);
//app.route("api/v1/teams", teams);

console.log(`Server is running on port ${port}`);

serve({
  fetch: app.fetch,
  port,
});

export default app;
