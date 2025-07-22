package Filter;

import Dao.RememberMeTokenDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import Model.RememberMeToken;

import java.io.IOException;

public class RememberMeFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response);
            return;
        }

        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("remember_token".equals(c.getName())) {
                    String token = c.getValue();
                    RememberMeTokenDao tokenDao = new RememberMeTokenDao();
                    RememberMeToken rememberToken = tokenDao.findValidToken(token);
                    if (rememberToken != null) {
                        req.getSession(true).setAttribute("user", rememberToken.getUser());
                        break;
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }
}
