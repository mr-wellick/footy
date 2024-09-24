import { Hono } from "hono";
import prisma from "../../libs/prisma";
import { leagues } from "@prisma/client";
import { FC } from "hono/jsx";

const app = new Hono();

export const ErrorView: FC<{ message: string }> = (props) => {
  console.log(props.message);
  return <p>Unable to retrive data for league. Please try again.</p>;
};

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
