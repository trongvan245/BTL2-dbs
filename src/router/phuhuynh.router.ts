import express from "express";
import { asyncHandler } from "../utils";

const router = express.Router();
router.get("/", asyncHandler(async (req, res) => {}));
router.post("/add", asyncHandler(async (req, res) => {}));
router.put("/update", asyncHandler(async (req, res) => {}));
router.delete("/delete", asyncHandler(async (req, res) => {}));