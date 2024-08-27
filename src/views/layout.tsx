import type { FC } from "hono/jsx";

const Layout: FC = () => {
  return (
    <html>
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Footy</title>
      </head>
      <body>
        <h1>welcome to footy.</h1>
      </body>
    </html>
  );
};

export default Layout;
