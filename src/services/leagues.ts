import { Hono } from "hono";
import prisma from "../db";
const app = new Hono();

app.get("/leagues", async (c) => {
  const leagues = await prisma.leagues.findMany();
  return c.json(leagues, 200);
});

export default app;
