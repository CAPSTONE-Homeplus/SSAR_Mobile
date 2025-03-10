package com.example.home_clean;

import android.os.Bundle;
import android.view.WindowManager;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Thêm cờ FLAG_SECURE để ngăn chụp màn hình
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
    }
}
