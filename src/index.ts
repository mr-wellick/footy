import { serve } from "@hono/node-server";
import { Hono } from "hono";
import countries from "./services/countries";

const app = new Hono();

const port = 3000;

app.route("/", countries);

console.log(`Server is running on port ${port}`);

serve({
  fetch: app.fetch,
  port,
});
