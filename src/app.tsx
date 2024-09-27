import { Hono } from "hono";
import { serveStatic } from "@hono/node-server/serve-static";
import { swaggerUI } from "@hono/swagger-ui";
import leagues from "./services/leagues";
import teams from "./services/teams";
import { swaggerDoc } from "../doc/swaggerDoc";
import { cors } from "hono/cors";

const app = new Hono();

// static files
app.use("/src/public/*", serveStatic({ root: "./" }));
app.use("/*", serveStatic({ rewriteRequestPath: (path) => `./dist${path}` }));
app.use("api/v1/*", cors({ origin: ["http://localhost:5173"] }));

// api documentation
app.get("/doc", (c) => c.json(swaggerDoc));
app.get("/ui", swaggerUI({ url: "/doc" }));

// routes
app.route("api/v1/leagues", leagues);
app.route("api/v1/teams", teams);

export default app;
