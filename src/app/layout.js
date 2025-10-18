import 'bootstrap/dist/css/bootstrap.min.css';
import { Inter } from 'next/font/google';
import './globals.css';
import Link from 'next/link';

const inter = Inter({ subsets: ['latin'] });

export const metadata = {
  title: 'Gestion Restaurateur',
  description: 'Application de gestion pour restaurants',
};

export default function RootLayout({ children }) {
  return (
    <html lang="fr">
      <body className={inter.className}>
        <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
          <div className="container-fluid">
            <Link href="/" className="navbar-brand">
              LA TABLE DE YEMMA
            </Link>
            <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
              <span className="navbar-toggler-icon"></span>
            </button>
            <div className="collapse navbar-collapse" id="navbarNav">
              <ul className="navbar-nav ms-auto">
                <li className="nav-item">
                  <Link href="/tablet/caisse" className="nav-link">
                    Caisse
                  </Link>
                </li>
                <li className="nav-item">
                  <Link href="/cuisine" className="nav-link">
                    Cuisine
                  </Link>
                </li>
                <li className="nav-item">
                  <Link href="/admin" className="nav-link">
                    Admin
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </nav>
        <main className="mt-4">
          {children}
        </main>
      </body>
    </html>
  );
}
