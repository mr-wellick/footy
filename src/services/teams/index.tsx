import { Hono } from "hono";
import prisma from "../../libs/prisma";
import { teams } from "@prisma/client";
//import { zValidator } from "@hono/zod-validator";
//import { z } from "zod";

const app = new Hono();

app.post(
  "/",
  //zValidator(
  //  "",
  //  z.object({
  //    "content-type": z
  //      .string()
  //      .refine((value) => value === "application/x-www-form-urlencoded", {
  //        message: "Content-Type must be application/x-www-form-urlencoded",
  //      }),
  //  })
  //),
  async (c) => {
    let result: teams[] = [];

    try {
      const { league_id } = await c.req.json();
      result = await prisma.teams.findMany({
        where: { league_id },
      });
    } catch (error) {
      console.log(error);
      return c.json(result, 500);
    }

    return c.json(result, 200);
  }
);

export default app;
