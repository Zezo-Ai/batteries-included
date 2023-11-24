defmodule CommonUI.Icons.Monitoring do
  @moduledoc false
  use CommonUI.Component

  attr :class, :any, default: nil

  def grafana_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      viewBox="0 0 24 24"
      class={["h-6 w-6 ", @class]}
      stroke="currentColor"
      fill="currentColor"
    >
      <path d="M22.999 10.626c-.043-.405-.106-.873-.234-1.384s-.341-1.065-.618-1.661c-.298-.575-.66-1.193-1.15-1.768-.192-.234-.405-.447-.618-.681.341-1.342-.405-2.513-.405-2.513-1.299-.085-2.108.405-2.406.618-.043-.021-.106-.043-.149-.064-.213-.085-.447-.17-.681-.256-.234-.064-.469-.149-.703-.192-.234-.064-.49-.106-.745-.149-.043 0-.085-.021-.128-.021C14.608.766 12.99 0 12.99 0c-1.853 1.193-2.215 2.79-2.215 2.79s0 .043-.021.085c-.106.021-.192.064-.298.085-.128.043-.277.085-.405.149s-.277.106-.405.17c-.277.128-.532.256-.809.405a8.52 8.52 0 0 0-.745.469c-.043-.021-.064-.043-.064-.043-2.492-.958-4.706.192-4.706.192-.192 2.662 1.001 4.323 1.235 4.621-.064.17-.106.319-.17.49a10.658 10.658 0 0 0-.405 1.853c-.021.085-.021.192-.043.277-2.3 1.129-2.981 3.471-2.981 3.471 1.917 2.215 4.174 2.343 4.174 2.343a9.61 9.61 0 0 0 .98 1.448c.149.192.319.362.49.554-.703 2.002.106 3.684.106 3.684 2.151.085 3.556-.937 3.854-1.171l.639.192c.66.17 1.342.277 2.002.298h.873c1.001 1.448 2.79 1.64 2.79 1.64 1.256-1.342 1.342-2.641 1.342-2.939v-.021-.043-.064c.256-.192.511-.383.767-.596.511-.447.937-.98 1.32-1.533.043-.043.064-.106.106-.149 1.427.085 2.428-.894 2.428-.894-.234-1.491-1.086-2.215-1.256-2.343l-.021-.021-.021-.021-.021-.021c0-.085.021-.17.021-.277.021-.17.021-.319.021-.49v-.213-.277-.128c0-.043 0-.085-.021-.128l-.043-.256c-.021-.17-.064-.319-.085-.49a6.327 6.327 0 0 0-.724-1.789 6.634 6.634 0 0 0-1.214-1.448 5.89 5.89 0 0 0-1.533-.98 5.368 5.368 0 0 0-1.682-.469c-.277-.043-.575-.043-.852-.043h-.128-.298c-.149.021-.298.043-.426.064-.575.106-1.107.319-1.576.596s-.873.639-1.214 1.043a4.284 4.284 0 0 0-.767 1.299c-.17.447-.277.937-.298 1.384v.511c0 .064 0 .106.021.17a3.642 3.642 0 0 0 .703 1.81c.256.341.532.596.852.809.319.213.639.362.98.469s.66.149.958.128h.446c.043 0 .085-.021.106-.021.043 0 .064-.021.106-.021.064-.021.149-.043.213-.064.128-.043.256-.106.383-.149.128-.064.234-.128.319-.192.021-.021.064-.043.085-.064a.24.24 0 0 0 .043-.341.298.298 0 0 0-.319-.064c-.021.021-.043.021-.085.043a1.43 1.43 0 0 1-.277.106c-.106.021-.213.064-.319.085-.064 0-.106.021-.17.021h-.361s-.021 0 0 0h-.086c-.022 0-.064 0-.085-.021-.234-.043-.49-.106-.724-.213s-.469-.256-.66-.447c-.213-.192-.383-.405-.532-.66s-.234-.532-.277-.809c-.021-.149-.043-.298-.021-.447v-.128c0 .021 0 0 0 0v-.043-.064c0-.085.021-.149.043-.234a3.114 3.114 0 0 1 .916-1.725c.128-.128.256-.234.405-.319.149-.106.298-.192.447-.256s.319-.128.49-.17c.17-.043.341-.085.511-.085.085 0 .17-.021.256-.021H15.228c.021 0 0 0 0 0h.085a4.046 4.046 0 0 1 1.619.49c.681.383 1.256.958 1.597 1.661.17.341.298.724.362 1.129.021.106.021.192.043.298v.554c0 .106-.021.213-.021.319-.021.106-.021.213-.043.319l-.064.319c-.021.106-.128.405-.192.618s-.362.788-.618 1.129a5.164 5.164 0 0 1-2.002 1.64c-.405.17-.809.319-1.235.383a3.221 3.221 0 0 1-.639.064h-.319c.021 0 0 0 0 0h-.021c-.106 0-.234 0-.341-.021-.469-.043-.916-.128-1.363-.256s-.873-.298-1.278-.511a6.956 6.956 0 0 1-2.108-1.746c-.277-.362-.532-.745-.745-1.15s-.362-.831-.49-1.256a5.489 5.489 0 0 1-.213-1.32v-.49-.17c0-.213.021-.447.064-.681.021-.234.064-.447.106-.681s.106-.447.17-.681.277-.873.469-1.278c.383-.809.873-1.533 1.448-2.108.149-.149.298-.277.469-.405.064-.064.213-.192.383-.298s.341-.213.532-.298c.085-.043.17-.085.277-.128.043-.021.085-.043.149-.064.043-.021.085-.043.149-.064.192-.085.383-.149.575-.213.043-.021.106-.021.149-.043s.106-.021.149-.043.192-.043.298-.085c.043-.021.106-.021.149-.043.043 0 .106-.021.149-.021s.106-.021.149-.021l.17-.043c.043 0 .106-.021.149-.021.064 0 .106-.021.17-.021.043 0 .128-.021.17-.021s.064 0 .106-.021h.149c.064 0 .106 0 .17-.021h.085s.021 0 0 0H15.033c.383.021.767.064 1.129.128a7.234 7.234 0 0 1 2.044.681 7.676 7.676 0 0 1 1.661 1.086c.021.021.064.043.085.085.021.021.064.043.085.085.064.043.106.106.17.149s.106.106.17.149c.043.064.106.106.149.17a7.88 7.88 0 0 1 1.406 1.98c.021.021.021.043.043.085.021.021.021.043.043.085s.043.106.085.149c.021.043.043.106.064.149s.043.106.064.149c.085.192.149.383.213.575.106.298.17.554.234.767a.204.204 0 0 0 .192.149c.106 0 .17-.085.17-.192-.021-.256-.021-.532-.043-.852z" />
    </svg>
    """
  end

  attr :class, :any, default: nil

  def victoria_metrics_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 464.61 533.89"
      class={["h-6 ", @class]}
      stroke="currentColor"
      fill="currentColor"
    >
      <path
        class="cls-1"
        d="M459.86,467.77c9,7.67,24.12,13.49,39.3,13.69v0h1.68v0c15.18-.2,30.31-6,39.3-13.69,47.43-40.45,184.65-166.24,184.65-166.24,36.84-34.27-65.64-68.28-223.95-68.47h-1.68c-158.31.19-260.79,34.2-224,68.47C275.21,301.53,412.43,427.32,459.86,467.77Z"
        transform="translate(-267.7 -233.05)"
      /><path
        class="cls-1"
        d="M540.1,535.88c-9,7.67-24.12,13.5-39.3,13.7h-1.6c-15.18-.2-30.31-6-39.3-13.7-32.81-28-148.56-132.93-192.16-172.7v60.74c0,6.67,2.55,15.52,7.09,19.68,29.64,27.18,143.94,131.8,185.07,166.88,9,7.67,24.12,13.49,39.3,13.69v0h1.6v0c15.18-.2,30.31-6,39.3-13.69,41.13-35.08,155.43-139.7,185.07-166.88,4.54-4.16,7.09-13,7.09-19.68V363.18C688.66,403,572.91,507.9,540.1,535.88Z"
        transform="translate(-267.7 -233.05)"
      /><path
        class="cls-1"
        d="M540.1,678.64c-9,7.67-24.12,13.49-39.3,13.69v0h-1.6v0c-15.18-.2-30.31-6-39.3-13.69-32.81-28-148.56-132.94-192.16-172.7v60.73c0,6.67,2.55,15.53,7.09,19.69,29.64,27.17,143.94,131.8,185.07,166.87,9,7.67,24.12,13.5,39.3,13.7h1.6c15.18-.2,30.31-6,39.3-13.7,41.13-35.07,155.43-139.7,185.07-166.87,4.54-4.16,7.09-13,7.09-19.69V505.94C688.66,545.7,572.91,650.66,540.1,678.64Z"
        transform="translate(-267.7 -233.05)"
      />
    </svg>
    """
  end

  attr :class, :any, default: nil

  def prometheus_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      viewBox="-4.98 -1.48 441.22 435.47"
      class={["h-6 w-6 ", @class]}
      stroke="currentColor"
      fill="currentColor"
    >
      <path d="M216.199 7.102c116.369.024 211.887 94.34 211.74 209.076-.148 116.479-95.275 209.487-214.174 209.403C97.524 425.5 3.54 331.086 3.622 214.477 3.702 100.451 99.418 7.078 216.199 7.102zm-64.326 73.434c2.667 13.055.076 25.231-3.868 37.207-2.732 8.293-6.508 16.278-8.763 24.684-3.716 13.851-7.931 27.783-9.477 41.949-2.223 20.37 5.83 38.312 19.609 56.152l-63.339-13.257c.111 1.99-.007 2.743.211 3.381 6.003 17.533 16.568 32.305 28.411 46.23 1.253 1.473 4.106 2.23 6.219 2.234 63.154.116 126.309.109 189.464.028 1.959-.003 4.573-.371 5.775-1.627 13.536-14.147 23.887-30.257 30.358-50.554l-67.053 13.053c4.423-8.617 9.472-16.195 12.375-24.522 9.928-28.483 5.813-56.02-8.437-81.992-11.436-20.843-21.984-41.594-16.279-66.713-12.079 11.855-16.716 26.948-19.66 42.503-2.899 15.32-4.607 30.866-6.852 46.409-.319-.469-.732-.816-.797-1.219-.26-1.631-.502-3.274-.59-4.922-1.364-25.46-6.366-49.991-16.922-73.419-6.214-13.791-13.067-27.891-6.661-44.342-4.335 2.273-8.253 4.531-11.062 7.756-8.383 9.626-11.849 21.187-12.741 33.845-.762 10.814-1.806 21.679-3.823 32.314-2.119 11.175-5.48 22.129-13.032 32.4-3.053-21.941-3.392-43.639-23.066-57.578zm162.836 217.806H116.628v34.208h198.081v-34.208zm-158.806 51.88c-.163 28.485 29.022 49.707 65.092 48.167 29.892-1.276 56.348-24.656 54.073-48.167H155.903z" />
    </svg>
    """
  end

  attr :class, :any, default: nil

  def alertmanager_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      stroke-width="2"
      class={["h-6 w-6 ", @class]}
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
      />
    </svg>
    """
  end
end
