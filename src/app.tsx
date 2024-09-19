import { Hono } from "hono";
import { serveStatic } from "@hono/node-server/serve-static";
import { swaggerUI } from "@hono/swagger-ui";
import leagues from "./services/leagues";
import teams from "./services/teams";
import { swaggerDoc } from "../doc/swaggerDoc";
import { jsxRenderer } from "hono/jsx-renderer";
import Navbar from "./views/components/navbar";

const app = new Hono();

// static files
app.use("/src/public/*", serveStatic({ root: "./" }));

app.use(
  "/*",
  jsxRenderer(
    ({ children }) => {
      return (
        <html data-theme="cyberpunk">
          <head>
            <meta charset="UTF-8" />
            <meta
              name="viewport"
              content="width=device-width, initial-scale=1.0"
            />
            <title>Footy</title>
            <link href="/src/public/output.css" rel="stylesheet" />
          </head>
          <body>{children}</body>
          <script
            src="https://unpkg.com/htmx.org@1.9.10"
            integrity="sha384-D1Kt99CQMDuVetoL1lrYwg5t+9QdHe7NLX/SoJYkXDFfX37iInKRy5xLSi8nO7UC"
            crossorigin="anonymous"
          ></script>
          <script src="https://unpkg.com/htmx-ext-response-targets@2.0.0/response-targets.js"></script>
        </html>
      );
    },
    {
      docType:
        '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">',
    }
  )
);

// api documentation
app.get("/doc", (c) => c.json(swaggerDoc));
app.get("/ui", swaggerUI({ url: "/doc" }));

// routes
app.get("/", (c) =>
  c.render(
    <>
      <Navbar />
    </>
  )
);
app.route("api/v1/leagues", leagues);
app.route("api/v1/teams", teams);

export default app;
