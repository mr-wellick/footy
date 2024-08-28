import type { FC } from "hono/jsx";
import Navbar from "../components/navbar";
import Leagues from "../services/leagues/view";

const Layout: FC = () => {
  return (
    <html data-theme="cyberpunk">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Footy</title>
        <link href="/src/public/output.css" rel="stylesheet" />
      </head>
      <body>
        <Navbar />
        <Leagues />
      </body>
      <script
        src="https://unpkg.com/htmx.org@1.9.10"
        integrity="sha384-D1Kt99CQMDuVetoL1lrYwg5t+9QdHe7NLX/SoJYkXDFfX37iInKRy5xLSi8nO7UC"
        crossorigin="anonymous"
      ></script>
    </html>
  );
};

export default Layout;
