import { Hono } from "hono";
import prisma from "../../db";
import { leagues } from "@prisma/client";
import Leagues from "./view";

const app = new Hono();

app.get("/", async (c) => {
  let result: leagues[] = [];

  try {
    result = await prisma.leagues.findMany();
  } catch (error) {
    console.error(error);
    return c.json({ message: "something went wrong" }, 500);
  }

  return c.html(<Leagues leagues={result} />);
});

export default app;
