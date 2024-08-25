import { serve } from "@hono/node-server";
import { Hono } from "hono";
import countries from "./services/countries";
import leagues from "./services/leagues";

const app = new Hono();

const port = 3000;

app.route("/", countries);
app.route("/", leagues);

console.log(`Server is running on port ${port}`);

serve({
  fetch: app.fetch,
  port,
});
