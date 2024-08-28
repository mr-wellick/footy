import { serve } from "@hono/node-server";
import { Hono } from "hono";
import leagues from "./services/leagues";
import { html } from "hono/html";
import Layout from "./views/layout";
import { serveStatic } from "@hono/node-server/serve-static";

const app = new Hono();
const port = 3000;

app.use("/src/public/*", serveStatic({ root: "./" }));

app.get("/", (c) => c.html(html`<!doctype html>${(<Layout />)}`));
app.route("/leagues", leagues);

console.log(`Server is running on port ${port}`);

serve({
  fetch: app.fetch,
  port,
});
