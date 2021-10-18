Giao diện cảm biến - Sensor Interface (Version 2.0)

============================================

* Hướng dẫn sử dụng:
--------------------

_ Mở matlab, để sẵn Current Folder ở nơi lưu trữ phần mềm
_ Gõ "Sensor_Interface" vào Command Window, hoặc nhấn trực tiếp vào file Sensor_Interface.fig
_ Nhấn nút On/Off trên góc trái màn hình
_ Chọn cổng serial để đọc dữ liệu từ thiết bị, nhấn Connect. Nếu hiện lên NO PORT, kiểm tra lại kết nối cổng USB, nhấn Search để tự động tìm cổng. Chọn BaudRate - tốc độ truyền dữ liệu, nhấn Set up khi hoàn tất.
_ Save và Load file excel trong thư mục Save có sẵn.
_ Nút Calibrate sẽ mở ra cửa sổ để chuẩn hóa giá trị đo. Cửa sổ gồm:
 + Calib: ON/OFF để bật tắt chế độ chuẩn hóa
 + Reset để xóa dữ liệu chuẩn hóa
 + Send để gửi tín hiệu điều khiển
 + Get Value để lấy dữ liệu về 1 lần
 + 2 kiểu chuẩn hóa theo đường thẳng Linear (xấp xỉ) và đa thức bậc n Lagrange (chính xác điểm)
_ Delay là khoảng thời gian giữa 2 lần lấy mẫu (theo giây), Num là số lượng mẫu muốn đo, Gain là hệ số tỉ lệ trong toàn thời gian đo.
_ Nhấn Properties và thực hiện:
 + Nhập định dạng dữ liệu gửi lên Matlab: '%f' giá trị số đo được, '\' xuống dòng, 'abc 123' gửi các kí tự cố định (vd: println('32 rpm') --> %f rpm\). Nhấn Help để tìm hiểu kĩ.
 + Chọn tên và đơn vị cho các giá trị lấy về (số giá trị bằng số lượng '%f' vừa nhập):
  - Add để thêm tên và đơn vị đã nhập (mặc định là Volt (V))
  - Delete sau khi chọn một tên đã có trong bảng để xóa
  - Update sau khi chọn một tên đã có trong bảng và chỉnh sửa để cập nhật
 + Chọn các đặc tính cho plot (đường, điểm, lưới)
 + Reset các giá trị:
  - Data là các giá trị đang có trong bảng giá trị
  - Value Set để đưa các lựa chọn trong phần Value Set về mặc định
  - Plot để đưa các đặc tính của đồ thị về mặc định
_ Nhập chuỗi kí tự muốn gửi đến thiết bị để điều khiển, nhấn Enter hoặc nút Send để gửi đi. Dữ liệu gửi đi tự động kèm theo kí tự "\" ở cuối để xử lý.
_ Nhấn Acquire để bắt đầu đo, Stop để dừng đo
_ Min, Average, Max để lấy các giá trị đã đo tương ứng

=====================================

* Lập trình phần cứng (code Arduino)
------------------------------------

_ Serial.print/println() để gửi dữ liệu cho Matlab.
_ Serial.read/readBytes/readBytesUntil (đọc / đọc với số byte/ đọc đến khi nhận được byte) để nhận dữ liệu dạng chuỗi kí tự từ Matlab.

=====================================

* Lưu ý
-------

_ Không đặt file cài trong đường dẫn viết có dấu
_ Khi gặp lỗi hiện ra những dòng màu đỏ ở ngoài Command Window, nên thoát khỏi chương trình và khởi động lại (tùy lúc có thể chỉ cần nhấn OFF rồi ON trở lại) (biết sửa code thì ok, không thì thôi)
_ Không đổi tên thư mục có sẵn (Save, Library)
_ Không di chuyển thư mục có sẵn (Để nguyên các file trong 1 thư mục mới sử dụng được)
_ Không tạo thư mục mới trong thư mục Save (Save chỉ dùng lưu file excel, load chỉ lấy được dữ liệu trong thư mục Save)
_ Không tự chuyển Current Folder trong Matlab khi đang chạy chương trình (có thể gặp lỗi, máy tự chuyển thì được)

======================================   END   ==================================
