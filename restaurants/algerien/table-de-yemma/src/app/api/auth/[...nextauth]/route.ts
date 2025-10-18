import NextAuth, { SessionStrategy } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import { prisma } from "../../../../lib/prisma";
import { compare } from "bcryptjs";

const authOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "text" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) return null;
  const user = await prisma.user.findUnique({ where: { email: credentials.email }, select: { id: true, email: true, password: true, role: true } });
  if (!user) return null;
  console.log('USER PRISMA:', user);
        const isValid = await compare(credentials.password, user.password);
        if (!isValid) return null;
  return { id: String(user.id), email: user.email, role: user.role ?? "CLIENT" };
      },
    }),
  ],
  session: { strategy: "jwt" as SessionStrategy },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.role = user.role;
      }
      return token;
    },
    async session({ session, token }) {
      if (token) {
        session.user.id = token.id;
        session.user.role = token.role;
      }
      return session;
    },
  },
  pages: {
    signIn: "/login",
  },
};

const handler = NextAuth(authOptions);
export { handler as GET, handler as POST };
