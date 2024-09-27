import { Hono } from "hono";
import prisma from "../../libs/prisma";
import { leagues } from "@prisma/client";

const app = new Hono();

app.get("/", async (c) => {
  let result: leagues[] = [];

  try {
    result = await prisma.leagues.findMany();
  } catch (error) {
    console.error(error);
    return c.json(result, 500);
  }

  return c.json(result, 200);
});

export default app;
