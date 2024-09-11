import { describe, it } from "node:test";
import app from "../../index";
import assert from "node:assert";
import prisma from "../../db";

describe("leagues controller", () => {
  it("200 status code: return drop down with all available leagues, if any ", async () => {
    const res = await app.request("api/v1/leagues");

    assert.strictEqual(200, res.status);
  });
});

describe("leagues controller", () => {
  it("500 status code: return an error view", async (t) => {
    // looks like the issue might have something to do with prisma: look into mocking out prisma client
    //  - https://github.com/nodejs/node/issues/52015
    // possible solution: https://www.prisma.io/docs/orm/prisma-client/testing/unit-testing
    t.mock.method(prisma.leagues, "findMany", async () => {
      throw new Error("Database error");
    });

    const res = await app.request("api/v1/leagues");

    assert.equal(res.status, 500);
  });
});
