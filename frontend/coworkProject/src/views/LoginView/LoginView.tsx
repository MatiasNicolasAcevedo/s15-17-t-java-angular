import { LoginForm } from "./LoginForm/LoginForm";

const LoginView = () => {
  return (
    <section className="bg-[#31543D] min-h-screen flex items-center justify-center">
      <div className="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
        <div className="w-full bg-white rounded-lg shadow md:mt-0 sm:max-w-md xl:p-0">
          <div className="p-6 space-y-1 md:space-y-3 sm:p-8">
            <h1 className="text-lg font-bold leading-tight tracking-tight text-[#31543D] md:text-2xl">
              Inicia Sesión en WoodWork
            </h1>
            <p className="text-sm text-center leading-tight tracking-tight text-gray-900 md:text-2xl">
              Ingresa tus credenciales:
            </p>
            <LoginForm />
          </div>
        </div>
      </div>
    </section>
  );
};

export default LoginView;
