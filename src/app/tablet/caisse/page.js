'use client';

import { useEffect } from 'react';
import Swal from 'sweetalert2';

export default function CaissePage() {
  useEffect(() => {
    require('bootstrap/dist/js/bootstrap.bundle.min.js');
  }, []);

  const handleShowAlert = () => {
    Swal.fire({
      title: 'Succès!',
      text: 'SweetAlert2 fonctionne parfaitement dans Next.js.',
      icon: 'success',
      confirmButtonText: 'OK'
    });
  };

  return (
    <div className="container mt-5">
      <h1 className="text-center">Bienvenue sur la Caisse Enregistreuse</h1>
      <p className="text-center text-muted">Ceci est une page rendue par Next.js/React.</p>
      <div className="d-flex justify-content-center">
        <button onClick={handleShowAlert} className="btn btn-primary mt-3">
          Test SweetAlert2
        </button>
      </div>
    </div>
  );
}
