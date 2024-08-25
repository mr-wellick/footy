import { Hono } from "hono";
import prisma from "../db";
const app = new Hono();

app.get("/countries", async (c) => {
  const countries = await prisma.country_codes.findMany();
  return c.json(countries, 200);
});

export default app;
