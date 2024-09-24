import { describe, expect, it, vi } from "vitest";
import app from "../../app";
import { prisma as prismaMock } from "../../libs/__mocks__/prisma";

vi.mock("../../libs/__mocks__/prisma", async () => {
  const actual = await vi.importActual("../../libs/__mocks__/prisma");
  return {
    ...actual,
  };
});

describe("Leagues Controller", () => {
  it("200: returns an array of leagues", async () => {
    const res = await app.request("api/v1/leagues");

    expect(res.status).toStrictEqual(200);
  });

  it("500: returns an empty array and error message", async () => {
    const myBlob = new Blob();
    const myOptions = { status: 500, result: [] };
    const myResponse = new Response(myBlob, myOptions);

    prismaMock.leagues.findMany.mockRejectedValue(myResponse);

    const res = await app.request("api/v1/leagues");

    expect(res.status).toStrictEqual(500);
  });
});
