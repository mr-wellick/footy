import { serve } from "@hono/node-server";
import { Hono } from "hono";
import leagues from "./services/leagues";
import { html } from "hono/html";
import Layout from "./views/layout";

const app = new Hono();

const port = 3000;

app.get("/", (c) => c.html(html`<!DOCTYPE html>${(<Layout />)}`));
app.route("/leagues", leagues);

console.log(`Server is running on port ${port}`);

serve({
  fetch: app.fetch,
  port,
});
