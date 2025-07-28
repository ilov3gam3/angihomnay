package Util;

import Dao.BookingDao;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class CronJobListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(() -> {
            // ✨ Mã cronjob bạn muốn chạy ở đây
            System.out.println("Cronjob running at: " + java.time.LocalDateTime.now());
//            new BookingDao().autocancelBooking();
            // ví dụ: dọn dữ liệu, gửi mail, kiểm tra trạng thái,...
        }, 0, 1, TimeUnit.MINUTES); // chạy mỗi 1 phút
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                System.out.println("Running... at " + java.time.LocalDateTime.now());
            }
        }, 0, 60 * 1000);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
        }
    }
}
