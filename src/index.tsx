import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { html } from "hono/html";
import { serveStatic } from "@hono/node-server/serve-static";
import leagues from "./services/leagues";
import teams from "./services/teams";
import Layout from "./views/layout";

const app = new Hono();
const port = 3000;

app.use("/src/public/*", serveStatic({ root: "./" }));

app.get("/", (c) => c.html(html`<!DOCTYPE html>${(<Layout />)}`));
app.route("api/v1/leagues", leagues);
app.route("api/v1/teams", teams);

console.log(`Server is running on port ${port}`);

serve({
  fetch: app.fetch,
  port,
});
