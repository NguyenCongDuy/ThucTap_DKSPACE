<div class="container py-4">
    <h2 class="mb-4 text-center">Xác thực 2 bước</h2>

    <form method="POST" action="{{ route('two-factor.verify') }}">
        @csrf

        <div class="mb-3">
            <label for="one_time_password" class="form-label">Mã xác thực 6 số</label>
            <input type="text" name="one_time_password" id="one_time_password" class="form-control" required autofocus maxlength="6" pattern="\d{6}">
            @error('one_time_password')
                <div class="text-danger mt-1">{{ $message }}</div>
            @enderror
        </div>

        <button type="submit" class="btn btn-primary w-100">Xác nhận</button>
    </form>
</div>

