import { createMiddleware } from "hono/factory";

const parseBody = createMiddleware(async (c, next) => {
  try {
    const body = await c.req.parseBody();
    c.set("parsedBody", body);
  } catch (e) {
    console.log("Error parsing body: ", e);
    return c.json({ message: "Invalid request body" }, 400);
  }

  await next();
});

export default parseBody;
