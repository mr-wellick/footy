import type { FC } from "hono/jsx";

const Layout: FC = ({ children }) => {
  return (
    <html data-theme="cyberpunk">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Footy</title>
        <link href="/src/public/output.css" rel="stylesheet" />
      </head>
      <body>{children}</body>
    </html>
  );
};

export default Layout;
