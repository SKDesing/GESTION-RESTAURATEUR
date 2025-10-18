import { NextApiRequest, NextApiResponse } from "next";
import { Server as ServerIO } from "socket.io";
import { Server as NetServer } from "http";

export const config = {
  api: {
    bodyParser: false,
  },
};

export default async function SocketHandler(
  req: NextApiRequest,
  res: NextApiResponse & { socket: any }
) {
  if (res.socket.server.io) {
    console.log("Socket is already running");
  } else {
    console.log("Socket is initializing");
    const httpServer: NetServer = res.socket.server as any;
    const io = new ServerIO(httpServer, {
      path: "/api/socket/io",
      addTrailingSlash: false,
    });
    res.socket.server.io = io;

    io.on("connection", (socket) => {
      console.log(`User connected: ${socket.id}`);
      socket.on("joinEtablissement", (etablissementId) => {
        socket.join(etablissementId);
        console.log(`User ${socket.id} joined room ${etablissementId}`);
      });
      socket.on("disconnect", () => {
        console.log(`User disconnected: ${socket.id}`);
      });
    });
  }
  res.end();
}
