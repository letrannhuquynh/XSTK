#library import
library(readr)
library(dplyr)
library(questionr)
library(ggplot2)
library(reshape2)
library(car)
#Đọc data từ file csv
#Assume that the file has address "C:/User/Nguyn/Downloads/cancer_reg.csv"
cancer_reg <- read.csv("C:/Users/Nguyn/Downloads/cancer_reg.csv")
head(cancer_reg, 3)

####################################################

#Lựa chọn các biến cần thiết
#Sử dụng lệnh select từ thư viện dplyr 
new_cancer_data <- cancer_reg %>% select("avganncount", "avgdeathsperyear", 
                                         "target_deathrate", "incidencerate",
                                         "medincome", "popest2015", "povertypercent",
                                         "studypercap", "binnedinc",
                                         "medianage", "birthrate",
                                         "geography")

####################################################

#Kiểm tra dữ liệu khuyết
#Đã lọc
freq.na(new_cancer_data)
#Gốc
freq.na(cancer_reg)


# Loại bỏ các cột không phải dạng số hoặc chứa dữ liệu khuyết trong cancer_reg
cleaned_data <- cancer_reg[, sapply(cancer_reg, function(column) {
  is.numeric(column) && !any(is.na(column))
})]

#Điều chỉnh bảng dữ liệu
#Cho phép thống kê theo đơn vị hành chính địa lý cấp bang (State)
# Thêm một cột 'State' để tách tiểu bang ra (sử dụng gsub)
new_cancer_data$State <- gsub(".*, ", "", new_cancer_data$geography)

####################################################

#freq.na(new_cancer_data)
#Tỉ lệ ung thư theo thành phố
resultByState <- new_cancer_data %>%
  group_by(State) %>%
  #Tổng số ca mắc(incidencerate) và tổng dân số theo bang (popest2015)
  summarise(IncidenceByState=sum(incidencerate), 
            PopByState=sum(popest2015), 
            AvgDeathByState=sum(avgdeathsperyear),
            AvgAnnByState=sum(avganncount))

#Tính tỉ lệ ung thư trên 100 dân
resultByState <- resultByState %>%
  mutate(
    InciRatePer100=(IncidenceByState/PopByState) *100,
    AvgDeathPer100=(AvgDeathByState/PopByState) *100,
    AvgAnnPer100=(AvgAnnByState/PopByState) *100
      )

####################################################
# Tắt định dạng số mũ
options(scipen = 999)

#Biểu đồ so sánh tỉ lệ dính ung thư
ggplot(resultByState, aes(x= reorder(State, InciRatePer100),
                          y=InciRatePer100)) +
  geom_col(fill="steelblue") +
  coord_flip() + 
  labs(
    title = "Tỉ lệ dính ung thư",
    x= "Bang",
    y="Tỉ lệ dính/100 dân"
  ) + 
  theme_minimal()

####################################################

#Phân tích tương quan
#correlation <- cor(resultByState$InciRatePer100,resultByState$AvgDeathPer100 )
#print(correlation)


#Trên biến avganncount
#Phân tích ANOVA
new_cancer_data$State <- as.factor(new_cancer_data$State)
new_cancer_data$geography <- as.factor(new_cancer_data$geography)
oneway.aov <- aov(avganncount ~ State, data = new_cancer_data)
summary(oneway.aov)

#Levene's test
leveneTest(avganncount ~ State, data = new_cancer_data)

####################################################

# Tạo kết quả TukeyHSD
tukey_results <- TukeyHSD(oneway.aov)

# Chuyển kết quả sang data frame
tukey_df <- as.data.frame(tukey_results$State) 

####################################################

#Vẽ heatmap cho các biến chỉ định
#Tạo data mới hỗ trợ vẽ heatmap
data <- cancer_reg %>% select("avganncount", "avgdeathsperyear", 
                                         "target_deathrate", "incidencerate",
                                         "medincome", "popest2015", "povertypercent",
                                         "studypercap", 
                                         "medianage", "birthrate"
                                          )
correlation <- cor(data)

# Đưa ma trận tương quan về dạng dataframe dài (long format)
melted_cor <- melt(correlation)

## Tạo heatmap với số hiển thị trên các ô
ggplot(data = melted_cor, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(value, 2)), color = "black", size = 4) + # Hiển thị số
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name="Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(title = "Heatmap of Variables Correlation",
       x = "", y = "")

####################################################

# Tính ma trận tương quan cho cleaned_data
cor_matrix <- cor(cleaned_data)

# Đưa ma trận tương quan về dạng dataframe dài (long format)
library(reshape2)
melted_cor <- melt(cor_matrix)

# Vẽ heatmap với số hiển thị
library(ggplot2)
ggplot(data = melted_cor, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(value, 2)), color = "black", size = 4) + # Hiển thị số
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name="Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(title = "Heatmap of Variables Correlation",
       x = "", y = "")

####################################################

# Tắt định dạng số mũ
options(scipen = 999)


# Thực hiện hồi quy tuyến tính
linear_model <- lm(avgdeathsperyear ~ avganncount + popest2015 +
                   pcths25_over + pctasian, data = cleaned_data)

# Xem kết quả của mô hình hồi quy
summary(linear_model)

 
####################################################

#THỐNG KÊ MÔ TẢ
# Lọc các biến cụ thể từ dữ liệu
selected_vars <- cancer_reg %>% select(avganncount, avgdeathsperyear,
                                       povertypercent, medincome
                                       )

summary_data <- sapply(selected_vars, function(x) {
  c(
    Mean = mean(x), #trung binh                  
    SD = sd(x), #Do lech chuan                  
    Min = min(x),#Gia tri nho nhat 
    Max = max(x), #Gia tri lon nhat                  
    PV1 = quantile(x, 0.25), #phan vi 1        
    Median = median(x), #Trung vi          
    PV3 = quantile(x, 0.75)  #Phan vi 3     
    
  )
})
t(summary_data)

#Histogram cho biến avgdeathsperyear
#Có chênh lệch rất lớn giữa các giá trị nên sử dụng log10 để giảm bề rộng trục x
ggplot(selected_vars, aes(x = log10(.data[["avgdeathsperyear"]]))) +
  geom_histogram(binwidth = 0.1, color = "black", fill = "skyblue") +
  labs(title = "Logarithmic Histogram of avgdeathsperyear",
       x = "log10(avgdeathsperyear)",
       y = "Frequency") +
  theme_minimal()


# Vẽ boxplot cho medincome
ggplot(selected_vars, aes(x = "", y = medincome)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  labs(title = "Boxplot of Median Income",
       x = "",
       y = "Median Income") +
  theme_minimal()



#Vẽ scatter plot cho povertypercent và target_deathrate
ggplot(cancer_reg, aes(x = povertypercent, y = target_deathrate)) +
  geom_point(color = "blue", alpha = 0.6) +
  labs(title = "Scatter Plot: Poverty Percent vs Target Death Rate",
       x = "Poverty Percent",
       y = "Target Death Rate") +
  theme_minimal()





